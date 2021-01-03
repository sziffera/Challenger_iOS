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
    @objc dynamic var date: String = "" /// dd-mm-yyyy. hh:mm
    @objc dynamic var firebaseId: String = "" /// UUID
    @objc dynamic var averageSpeed: Double = 0.0 /// in km/h
    @objc dynamic var maxSpeed: Double = 0.0 /// in km/h
    @objc dynamic var distance: Double = 0.0 /// in km
    @objc dynamic var duration: Double = 0.0 /// in sec
    @objc dynamic var type: String = ""
    
    var route = List<MyLocation>()
    
    required init() {
        //skip
    }
    
    init(name: String, date: String, firebaseId: String, averageSpeed: Double, maxSpeed: Double, distance: Double, duration: Double, type: String) {
        self.name = name
        self.date = date
        self.firebaseId = firebaseId
        self.averageSpeed = averageSpeed
        self.maxSpeed = maxSpeed
        self.distance = distance
        self.duration = duration
        self.type = type
        
    }

    override static func primaryKey() -> String? {
      return "firebaseId"
    }
 
}
