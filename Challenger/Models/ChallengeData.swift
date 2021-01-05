//
//  Challenge.swift
//  Challenger
//
//  Created by Andras Sziffer on 2020. 08. 23..
//  Copyright © 2020. Andras Sziffer. All rights reserved.
//

import Foundation

struct ChallengeData: Codable {
    let dur: Double
    let dst: Double
    let avg: Double
    let date: String
    let firebaseId: String
    let id: String
    let ms: Double
    let name: String
    let routeAsString: String
    let type: String
}

