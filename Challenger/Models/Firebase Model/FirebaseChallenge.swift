//
//  FirebaseChallenge.swift
//  Challenger
//
//  Created by Andras Sziffer on 2020. 09. 19..
//  Copyright © 2020. Andras Sziffer. All rights reserved.
//

import Foundation

struct FirebaseChallenge: Codable {
    var name: String = ""
    var date: String = ""
    var firebaseId: String = ""
    var avg: Double = 0.0
    var ms: Double = 0.0
    var dst: Double = 0.0
    var dur: Double = 0.0
    var type: String = ""
    var routeAsString = ""
}
