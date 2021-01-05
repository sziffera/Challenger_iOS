//
//  LocationUpdateService.swift
//  Challenger
//
//  Created by Andras Sziffer on 2020. 07. 11..
//  Copyright © 2020. Andras Sziffer. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit


class LocationTracking: NSObject {
    
    static var sharedInstance = LocationTracking()
    
    //unused
    private var filter: Bool = true
    
    private var locationManager: CLLocationManager = CLLocationManager()
    
    private var route: [MyLocation]?
    private var lastLocation: CLLocation?
    
    //for drawing the route onto the map
    private var polylineRoute: [CLLocationCoordinate2D]?
    
    // start time
    private var start: Double = 0.0
    
    private var distance: Double = 0.0 /// in metres
    private var duration: Double = 0.0 /// in sec
    private var durationHelper: Double = 0.0
    private var altitude: Double = 0.0 /// in metres
    private var speed: Double = 0.0 /// in m/s
    private var difference: Double = 0.0
    private var maxSpeed: Double = 0.0 /// in m/s
    
    private var cadence: Int = -1 /// in rpm -1 if not set
    private var heartRate: Int = -1 /// in bpm -1 if not set
    
    private var movingAverage: MovingAverage = MovingAverage(period: 4)
    
    private var myLocation: MyLocation?
    
    //helps calculating the difference - avoid looping the whole array
    private var counter: Int = 0
    
    private let whenToSaveLocation = 4 ///no need to save every location
    private var locationsGot = 0 ///counts the number of locations
    
    private var timer: RepeatingTimer? = RepeatingTimer(timeInterval: 1)
    
    //helper variables for auto pause
    private var zeroSpeed: Bool = false
    private var zeroSpeedPauseTime: Double = 0.0
    
    ///indicates whether a notification should be sent or not based on app state
    private var shouldUpdateView = true
    
    //setting the limit for auto pause in m/s appr. 2km/h
    private let autoPauseLimit: Double = 2 / 3.6
    
    override private init() {
        
        super.init()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(appCameToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(heartRateDataUpdated(_:)), name: .hearRateDataUpdated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(cadenceDataUpdated(_:)), name: .cadenceDataUpdated, object: nil)
        
        
        route = [MyLocation]()
        polylineRoute = [CLLocationCoordinate2D]()
        
        timer?.eventHandler = {
            if self.shouldUpdateView {
                self.updateUI()
            }
        }
        timer?.resume()
        
        distance = 0
        start = Date.timeIntervalSinceReferenceDate
        
        //Location manager init
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 1.5
        locationManager.activityType = .fitness
        locationManager.requestWhenInUseAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
    }
    
    // MARK: Recording handling
    
    func startTracking() {
        print("startTracking() called")
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            start = Date.timeIntervalSinceReferenceDate
            zeroSpeed = false
        } else {
            showLocationServicesNotEnabledAlert()
        }
    }
    
    func pauseTracking() {
        locationManager.stopUpdatingLocation()
        durationHelper += Date.timeIntervalSinceReferenceDate - start
        zeroSpeed = true
    }
    
    // MARK: helper methods
    
    func getRoute() -> [CLLocationCoordinate2D]? {
        return polylineRoute
    }
    
    /**
     Saves the challenge to the Realm database
     In this way, the challenge can be removed easily and the details can be fetched in Details view
     */
    func finishRecording() {
        
        locationManager.stopUpdatingLocation()
        
        DispatchQueue.main.async {
            let avgSpeed = (self.distance / self.duration) * 3.6
            print(avgSpeed)
            let now = Date()
            let formatter = DateFormatter()
            formatter.timeZone = TimeZone.current
            formatter.dateFormat = "yyyy-MM-dd. HH:mm"
            let date = formatter.string(from: now)
            
            let firebaseId = UUID().uuidString
            let challenge = Challenge(name: "new realm test", date: date, firebaseId: firebaseId, averageSpeed: avgSpeed, maxSpeed: self.maxSpeed*3.6, distance: self.distance / 1000, duration: self.duration, type: AppSettings.stringValue(.activityType) ?? "cycling")
            challenge.route.append(objectsIn: self.route ?? [])
            
            ChallengeManager.shared.save(challenge: challenge)
            
        }
        //resetting state
        timer = nil
        
        
        //        route = [MyLocation]()
        //        polylineRoute = [CLLocationCoordinate2D]()
        //        maxSpeed = 0.0
        //        lastLocation = nil
        //        zeroSpeedPauseTime = 0.0
        //        distance = 0.0
        //        duration = 0.0
        //        durationHelper = 0.0
        //        altitude = 0.0
        //        speed = 0.0
        //        difference = 0.0
        //        maxSpeed = 0.0
        //        cadence = 0
        //        heartRate = 0
        //        movingAverage = MovingAverage(period: 4)
        //        counter = 0
        //        locationsGot = 0
    }
    
    private func updateUI() {
        
        if myLocation != nil {
            //creating the notification for UI
            let currentTime = Date.timeIntervalSinceReferenceDate - start
            let myLocationDict: NSDictionary = [K.Notification.data: myLocation!,
                                                K.Notification.time: currentTime + durationHelper,
                                                K.Notification.zeroSpeed: zeroSpeed,
                                                K.Notification.maxSpeed: maxSpeed]
            
            NotificationCenter.default.post(name: .challengeDataUpdate, object: myLocationDict)
        }
    }
    
    private func showLocationServicesNotEnabledAlert() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "TurnOnLocationServicesAlert"), object: nil)
    }
    
    // MARK:- app state changes
    @objc func appMovedToBackground() {
        print("app enters background")
        shouldUpdateView = false
    }
    
    @objc func appCameToForeground() {
        print("app enters foreground")
        shouldUpdateView = true
    }
    
    // MARK:- sensor notifications
    @objc func cadenceDataUpdated(_ notification: NSNotification) {
        guard let rpm = notification.object as? Double else {return}
        self.cadence = Int(rpm)
    }
    
    @objc func heartRateDataUpdated(_ notification: NSNotification) {
        guard let bpm = notification.object as? Int else {return}
        self.heartRate = bpm
    }
    
    
}
// MARK: Location handling
extension LocationTracking: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]){
        
        if let newLocation = locations.last {
            //handling new location
            if lastLocation != nil {
                handleNewLocation(newLocation)
            }
            //updating the location
            lastLocation = newLocation
        }
    }
    
    private func handleNewLocation(_ newLocation: CLLocation) {
        
        if newLocation.speed > maxSpeed && newLocation.speed < 40 {
            maxSpeed = newLocation.speed
        }
        if AppSettings.boolValue(.autoPause) {
            if newLocation.speed < autoPauseLimit {
                
                if !zeroSpeed {
                    zeroSpeedPauseTime = Date.timeIntervalSinceReferenceDate
                }
                zeroSpeed = true
            } else {
                
                if zeroSpeed {
                    durationHelper -= Date.timeIntervalSinceReferenceDate - zeroSpeedPauseTime
                }
                zeroSpeed = false
            }
        }
        
        if !zeroSpeed {
            
            //the durationHelper is negative if any pause event occured, so must be added, not substracted
            duration = Date.timeIntervalSinceReferenceDate - start + durationHelper
            distance += newLocation.distance(from: lastLocation!)
            
            // corrected altitude is the moving average of the last n locations -> filters out errors
            let correctedAltitude = movingAverage.addNumber(newLocation.altitude)
            
            myLocation = MyLocation(latitude: newLocation.coordinate.latitude, longitude: newLocation.coordinate.longitude, distance: distance, time: duration, speed: newLocation.speed, altitude: correctedAltitude, bpm: heartRate, rpm: cadence)
            
            if locationsGot % whenToSaveLocation == 0 {
                print("locations saved")
                polylineRoute?.append(CLLocationCoordinate2D(latitude: newLocation.coordinate.latitude, longitude: newLocation.coordinate.longitude))
                route?.append(myLocation!)
            }
            locationsGot += 1
        }
    }
}
