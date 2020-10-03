//
//  RecorderPopUpSettingsViewController.swift
//  Challenger
//
//  Created by Andras Sziffer on 2020. 07. 26..
//  Copyright © 2020. Andras Sziffer. All rights reserved.
//

import UIKit

class UserSettingsViewController: UITableViewController {

    let defaults = UserDefaults.standard
    
    
    @IBOutlet weak var startStopSwitch: UISwitch!
    @IBOutlet weak var distanceSwitch: UISwitch!
    @IBOutlet weak var durationSwitch: UISwitch!
    @IBOutlet weak var averageSpeedSwitch: UISwitch!
    @IBOutlet weak var differenceSwitch: UISwitch!
    @IBOutlet weak var autoPauseSwitch: UISwitch!
    @IBOutlet weak var alwaysOnDisplaySwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(doneButtonPressed(sender:)))
        doneButton.tintColor = UIColor(named: "ColorDarkBlue")
        self.navigationItem.rightBarButtonItem = doneButton
        self.navigationItem.titleView?.tintColor = UIColor(named: "ColorDarkBlue")
        
        startStopSwitch.isOn = AppSettings.boolValue(.startStop)
        autoPauseSwitch.isOn = AppSettings.boolValue(.autoPause)
        averageSpeedSwitch.isOn = AppSettings.boolValue(.averageSpeed)
        differenceSwitch.isOn = AppSettings.boolValue(.difference)
        durationSwitch.isOn = AppSettings.boolValue(.duration)
        alwaysOnDisplaySwitch.isOn = AppSettings.boolValue(.alwaysOnDisplay)
        distanceSwitch.isOn = AppSettings.boolValue(.distance)
        
    }
    
    @objc func doneButtonPressed(sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    

    @IBAction func startStopSwitchChanged(_ sender: UISwitch) {
        AppSettings[.startStop] = startStopSwitch.isOn
    }
    @IBAction func distanceSwitchChanged(_ sender: UISwitch) {
        AppSettings[.distance] = distanceSwitch.isOn
    }
    @IBAction func durationSwitchChanged(_ sender: UISwitch) {
        AppSettings[.duration] = durationSwitch.isOn
    }
    @IBAction func averageSwitchChanged(_ sender: UISwitch) {
        AppSettings[.averageSpeed] = averageSpeedSwitch.isOn
    }
    @IBAction func differenceSwitchChanged(_ sender: UISwitch) {
        AppSettings[.difference] = differenceSwitch.isOn
    }
    @IBAction func autoPauseSwitchChanged(_ sender: UISwitch) {
        AppSettings[.autoPause] = autoPauseSwitch.isOn
    }
    @IBAction func alwaysOnDisplaySwitchChanged(_ sender: UISwitch) {
        AppSettings[.alwaysOnDisplay] = alwaysOnDisplaySwitch.isOn
    }
}
