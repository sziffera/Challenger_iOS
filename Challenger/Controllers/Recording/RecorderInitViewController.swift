//
//  RecorderSettingsViewController.swift
//  Challenger
//
//  Created by Andras Sziffer on 2020. 07. 20..
//  Copyright © 2020. Andras Sziffer. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class RecorderInitViewController: UIViewController {
    
    @IBOutlet weak var gspStateLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var backgroundGradientView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityTypeChooserButton: UIButton!
    @IBOutlet weak var voiceCoachButton: UIButton!
    @IBOutlet weak var bluetoothButton: UIButton!
    
    private var locationManager: CLLocationManager?
    
    private var activityCounter = 0
    
    private let activities =
        [K.ActivityTypes.cycling,
         K.ActivityTypes.running,
         K.ActivityTypes.indoor]
    
    private let defaults = UserDefaults.standard
    private var activityType: String = K.ActivityTypes.cycling
    private var voiceCoach: Bool = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        SpeedCadenceSensorConnection.shared.viewController = self
        
        if let lastActivity = AppSettings.stringValue(.activityType) {
            activityTypeChooserButton.setImage(UIImage(named: lastActivity), for: .normal)
            activityCounter = activities.firstIndex(of: lastActivity) ?? 0
            print(activityCounter)
        }
        
        startButton.layer.cornerRadius = 5
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor(named: "ColorDarkRed")!.cgColor,UIColor(named: "ColorDarkBlue")!.cgColor]
        gradientLayer.shouldRasterize = true
        backgroundGradientView.layer.addSublayer(gradientLayer)
        
        //setting the settings button in NavBar
        let settingsButton = UIBarButtonItem(title: "Settings", style: UIBarButtonItem.Style.plain, target: self, action: #selector(settingsButtonPressed(sender:)))
        self.navigationItem.leftBarButtonItem = settingsButton
        
        //setting the cancel button in NavBar
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelButtonPressed(sender:)))
        self.navigationItem.rightBarButtonItem = cancelButton
        
        
    }
    

    
    
    private func setActivityType() {
        
        if activityCounter < activities.count - 1 {
            activityCounter += 1
        } else {
            activityCounter = 0
        }
        activityTypeChooserButton.setImage(UIImage(named: activities[activityCounter]), for: .normal)
        AppSettings[.activityType] = activities[activityCounter]
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
               self.navigationController?.navigationBar.tintColor = UIColor.white
        voiceCoach = AppSettings.boolValue(.voiceCoachIsOn)
        if voiceCoach {
            voiceCoachButton.setImage(UIImage(named: K.Images.voiceCoachOn), for: .normal)
        } else {
            voiceCoachButton.setImage(UIImage(named: K.Images.voiceCoachOff), for: .normal)
        }
        print(#function)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Recording"
        navigationItem.backBarButtonItem = backItem
    }
    
    private func setVoiceCoach() {
        
        if voiceCoach {
            voiceCoachButton.setImage(UIImage(named: K.Images.voiceCoachOff), for: .normal)
            AppSettings[.voiceCoachIsOn] = false
        } else {
            voiceCoachButton.setImage(UIImage(named: K.Images.voiceCoachOn), for: .normal)
            AppSettings[.voiceCoachIsOn] = true
        }
        voiceCoach = !voiceCoach
    }
    
    
    
    @objc func cancelButtonPressed(sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "CancelRecorderSettings", sender: nil)
    }
    
    @objc func settingsButtonPressed(sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "OpenDetailedSettings", sender: nil)
    }
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "StartRecording", sender: nil)
    }
    @IBAction func activityTypeChooserPressed(_ sender: UIButton) {
        setActivityType()
    }
    @IBAction func voiceCoachPressed(_ sender: UIButton) {
        setVoiceCoach()
    }
    @IBAction func bluetoothPressed(_ sender: Any) {
        
    }
    
}

extension RecorderInitViewController: MKMapViewDelegate {
    
}
extension RecorderInitViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    locationManager?.desiredAccuracy = kCLLocationAccuracyBest
                    locationManager?.startUpdatingLocation()
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]){
        if let newLocation = locations.last {
            
            let viewRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: newLocation.coordinate.latitude, longitude: newLocation.coordinate.longitude), latitudinalMeters: 1000, longitudinalMeters: 1000)
            self.mapView.setRegion(viewRegion, animated: false)
            
            
            if newLocation.horizontalAccuracy >= locationManager!.desiredAccuracy {
                self.gspStateLabel.backgroundColor = .green
                self.gspStateLabel.text = "GPS ok"
                self.locationManager?.stopUpdatingLocation()
            } else {
                self.gspStateLabel.backgroundColor = UIColor(named: K.Color.plus)
                self.gspStateLabel.text = "Searching for GPS"
            }
            
        }
    }
}
