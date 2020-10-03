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
    private var filter: Bool = true
    
    private var locationManager: CLLocationManager = CLLocationManager()
    
    private var route: [MyLocation]?
    private var lastLocation: CLLocation?
    
    //for drawing the route onto the map
    private var polylineRoute: [CLLocationCoordinate2D]?
    
    private var start: Double = 0.0
    
    private var distance: Double = 0.0
    private var duration: Double = 0.0
    private var durationHelper: Double = 0.0
    private var altitude: Double = 0.0
    private var speed: Double = 0.0
    private var difference: Double = 0.0
    private var maxSpeed: Double = 0.0
    
    private var myLocation: MyLocation?
    
    //helps calculating the difference - avoid looping the whole array
    private var counter: Int = 0
    
    private var timer: RepeatingTimer? = RepeatingTimer(timeInterval: 1)
    
    //helper variables for auto pause
    private var zeroSpeed: Bool = false
    private var zeroSpeedPauseTime: Double = 0.0
    
    private var shouldUpdateView = true
    
    //setting the limit for auto pause in m/s appr. 2km/h
    private let autoPauseLimit: Double = 2 / 3.6
    
    override private init() {
        
        super.init()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 1.5
        locationManager.activityType = .fitness
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(appCameToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
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
        
        
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        
        locationManager.delegate = self
        
        
    }
    
    // MARK: Recording handling
    
    func startTracking() {
        print("startTracking() called")
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        } else {
            showLocationServicesNotEnabledAlert()
        }
    }
    
    func stopTracking() {
        locationManager.stopUpdatingLocation()
        timer = nil
    }
    
    
    
    
    // MARK: helper methods
    
    func getRoute() -> [CLLocationCoordinate2D]? {
        return polylineRoute
    }
    
    private func updateUI() {
        
        if myLocation != nil {
            //creating the notification for UI
            let currentTime = Date.timeIntervalSinceReferenceDate - start
            let myLocationDict: NSDictionary = ["data": myLocation!, "time": currentTime]
            NotificationCenter.default.post(name: .challengeDataUpdate, object: myLocationDict)
        }
    }
    
    private func showLocationServicesNotEnabledAlert() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "TurnOnLocationServicesAlert"), object: nil)
    }
    
    // MARK: app state changes
    @objc func appMovedToBackground() {
        print("app enters background")
        shouldUpdateView = false
    }
    
    @objc func appCameToForeground() {
        print("app enters foreground")
        shouldUpdateView = true
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
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            self.locationManager.requestAlwaysAuthorization()
        }
    }
    
    private func handleNewLocation(_ newLocation: CLLocation) {
        
        let elapsedTimeInSec = Date.timeIntervalSinceReferenceDate - start
        distance += newLocation.distance(from: lastLocation!)
        
        myLocation = MyLocation(latitude: newLocation.coordinate.latitude, longitude: newLocation.coordinate.longitude, distance: distance, time: elapsedTimeInSec, speed: newLocation.speed, altitude: newLocation.altitude)
        
        polylineRoute?.append(CLLocationCoordinate2D(latitude: newLocation.coordinate.latitude, longitude: newLocation.coordinate.longitude))
        route?.append(myLocation!)
        
    }
}
