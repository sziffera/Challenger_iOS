//
//  RecorderPopUpSettingsViewController.swift
//  Challenger
//
//  Created by Andras Sziffer on 2020. 07. 26..
//  Copyright © 2020. Andras Sziffer. All rights reserved.
//

import UIKit

class UserSettingsViewController: UITableViewController {

    @IBOutlet weak var voiceCoachEnabledSwitch: UISwitch!
    @IBOutlet weak var startStopSwitch: UISwitch!
    @IBOutlet weak var distanceSwitch: UISwitch!
    @IBOutlet weak var durationSwitch: UISwitch!
    @IBOutlet weak var averageSpeedSwitch: UISwitch!
    @IBOutlet weak var differenceSwitch: UISwitch!
    @IBOutlet weak var autoPauseSwitch: UISwitch!
    @IBOutlet weak var alwaysOnDisplaySwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor(named: K.Color.recording)]
        self.navigationController?.navigationBar.tintColor = UIColor(named: K.Color.recording)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        voiceCoachEnabledSwitch.isOn = AppSettings.boolValue(.voiceCoachIsOn)
        startStopSwitch.isOn = AppSettings.boolValue(.startStop)
        autoPauseSwitch.isOn = AppSettings.boolValue(.autoPause)
        averageSpeedSwitch.isOn = AppSettings.boolValue(.averageSpeed)
        differenceSwitch.isOn = AppSettings.boolValue(.difference)
        durationSwitch.isOn = AppSettings.boolValue(.duration)
        alwaysOnDisplaySwitch.isOn = AppSettings.boolValue(.alwaysOnDisplay)
        distanceSwitch.isOn = AppSettings.boolValue(.distance)
        
        setEnabledStatus()
        
    }
    
    private func setEnabledStatus() {
        let enabled = voiceCoachEnabledSwitch.isOn
        startStopSwitch.isEnabled = enabled
        distanceSwitch.isEnabled = enabled
        durationSwitch.isEnabled = enabled
        averageSpeedSwitch.isEnabled = enabled
        differenceSwitch.isEnabled = enabled
    }
    
   
    

    @IBAction func voiceCoachEnabledSwitchChanged(_ sender: UISwitch) {
        AppSettings[.voiceCoachIsOn] = voiceCoachEnabledSwitch.isOn
        setEnabledStatus()
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
