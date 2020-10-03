//
//  UserManager.swift
//  Challenger
//
//  Created by Andras Sziffer on 2020. 08. 29..
//  Copyright © 2020. Andras Sziffer. All rights reserved.
//

import Foundation
import Firebase
import RealmSwift

struct UserManager {
    static let shared = UserManager()
    private init(){}
    
    func getCyclingDistance() -> Double {
        return 0.0
    }
    func getRunningDistance() -> Double {
        return 0.0
    }
}
