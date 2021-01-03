//
//  AppSettings.swift
//  Challenger
//
//  Created by Andras Sziffer on 2020. 09. 01..
//  Copyright © 2020. Andras Sziffer. All rights reserved.
//

import Foundation

public enum AppSettings {

    
    public enum key: String {
        
        case username = "username"
        
        //ride settings
        case distance = "distance"
        case duration = "duration"
        case averageSpeed = "avgSpeed"
        case startStop = "startStop"
        case difference = "difference"
        case autoPause = "autoPause"
        case alwaysOnDisplay = "alwaysOnDisplay"
        case activityType = "activityType"
        case voiceCoachIsOn = "voiceCoach"
        
  }

    public static subscript(_ key: key) -> Any? {
        get {
            // need use `rawValue` to acess the string
            return UserDefaults.standard.value(forKey: key.rawValue)
        }
        set { 
            UserDefaults.standard.setValue(newValue, forKey: key.rawValue)
        }
    }
}
extension AppSettings {
    public static func boolValue(_ key: key) -> Bool {
        if let value = AppSettings[key] as? Bool {
            return value
        }
        return false
    }
    
    public static func stringValue(_ key: key) -> String? {
        if let value = AppSettings[key] as? String {
            return value
        }
        return nil
    }
    
    public static func intValue(_ key: key) -> Int? {
        if let value = AppSettings[key] as? Int {
            return value
        }
        return nil
    }
}
