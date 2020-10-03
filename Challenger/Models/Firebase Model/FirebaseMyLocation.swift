//
//  FirebaseMyLocation.swift
//  Challenger
//
//  Created by Andras Sziffer on 2020. 09. 19..
//  Copyright © 2020. Andras Sziffer. All rights reserved.
//

import Foundation
struct FirebaseMyLocation: Codable {
    let distance: Double
    let time: Double
    let speed: Double
    let altitude: Double
    let latLng: LatLng

}
