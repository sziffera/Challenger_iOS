//
//  Challenge.swift
//  Challenger
//
//  Created by Andras Sziffer on 2020. 09. 19..
//  Copyright © 2020. Andras Sziffer. All rights reserved.
//

import Foundation
import RealmSwift

class Challenge: Object {
    
    @objc dynamic var name: String = ""
    @objc dynamic var date: String = ""
    @objc dynamic var firebaseId: String = ""
    @objc dynamic var averageSpeed: Double = 0.0
    @objc dynamic var maxSpeed: Double = 0.0
    @objc dynamic var distance: Double = 0.0
    @objc dynamic var duration: Double = 0.0
    @objc dynamic var type: String = ""
    
    let route = List<MyLocation>()

    override static func primaryKey() -> String? {
      return "firebaseId"
    }
 
}
