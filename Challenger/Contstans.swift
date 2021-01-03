//
//  Contstans.swift
//  Challenger
//
//  Created by Andras Sziffer on 2020. 08. 23..
//  Copyright © 2020. Andras Sziffer. All rights reserved.
//

struct K {
    static let cellNib = "ChallengeTableViewCell"
    static let cellIdentifier = "ChallengeItemCell"
    static let detailsCellNib = "DetailTableViewCell"
    static let detailCellIdentifier = "detailCell"
    
    struct Segues {
        static let mainScreen = "StartMainScreen"
        static let loginScreen = "StartLoginScreen"
        static let recordingSettings = "StartRecordingSettings"
        static let settingsFromCreate = ""
        static let cancelRecording = "CancelRecorderSettings"
        static let detailedSettings = "OpenDetailedSettings"
        static let startMainAfterRegister = "StartMainScreenAfterRegister"
        static let recording = "StartRecording"
        static let signOut = "SignOutSegue"
        static let startSettingsFromProfile = "StartSettingsFromProfile"
        static let challengeDetails = "ChallengeDetails"
        static let indoorTraining = "IndoorTrainingSegue"
        static let finishedRecording = "showDetailsAfterRecording"
        static let discardPressed = "DiscardPressedSegue"
    }
    
    struct User {
        static let usernameKey = "username"
        static let startStop = "startStop"
        static let distance = "distance"
        static let difference = "difference"
        static let duration = "duration"
        static let autoPause = "autoPause"
        static let alwaysOnDisplay = "alwasyOnDisplay"
        static let avgSpeed = "avgSpeed"
    }
    
    struct Notification {
        static let time = "time"
        static let maxSpeed = "maxSpeed"
        static let data = "data"
        static let zeroSpeed = "zeroSpeed"
    }
    
    struct Images {
        static let mountainIcon = "mountain"
        static let cycling = "bike"
        static let running = "run"
        static let indoor = "indoor_trainer"
        static let voiceCoachOn = "voice_coach"
        static let voiceCoachOff = "voice_coach_off"
    }
    
    struct ActivityTypes {
        static let cycling = "cycling"
        static let running = "running"
        static let indoor = "indoor"
    }
    
    struct Color {
        static let recording = "ColorRecording"
        static let darkBlue = "ColorDarkBlue"
        static let darkRed = "ColorDarkRed"
        static let minus = "ColorMinus"
        static let plus = "ColorPlus"
        static let lightOpacity = "ColorLightOpacity"
        
        ///heart rate colors
        static let moderate = "ColorModerate"
        static let weightControl = "ColorWeightControl"
        static let aerobic = "ColorAerobic"
        static let anaerobic = "ColorAnaerobic"
        static let vo2max = "ColorVo2max"
    }
    struct Firebase {
        
    }
    
}
