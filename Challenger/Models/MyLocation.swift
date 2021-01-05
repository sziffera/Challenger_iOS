//
//  MyLocation.swift
//  Challenger
//
//  Created by Andras Sziffer on 2020. 07. 16..
//  Copyright © 2020. Andras Sziffer. All rights reserved.
//

import Foundation
import RealmSwift

class MyLocation: Object {
    @objc dynamic var latitude: Double = 0.0
    @objc dynamic var longitude: Double = 0.0
    @objc dynamic var distance: Double = 0.0
    @objc dynamic var time: Double = 0.0
    @objc dynamic var speed: Double = 0.0
    @objc dynamic var altitude: Double = 0.0
    @objc dynamic var heartRate: Int = -1
    @objc dynamic var cadence: Int = -1
    var parentChallenge = LinkingObjects(fromType: Challenge.self, property: "route")
    init(latitude: Double, longitude: Double, distance: Double, time: Double, speed: Double, altitude: Double, bpm: Int, rpm: Int) {
        self.latitude = latitude
        self.longitude = longitude
        self.distance = distance
        self.time = time
        self.speed = speed
        self.altitude = altitude
        self.heartRate = bpm
        self.cadence = rpm
    }
    required init() {
        //do nothing
    }
}
