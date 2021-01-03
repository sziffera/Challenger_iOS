//
//  TabBarController.swift
//  Challenger
//
//  Created by Andras Sziffer on 2020. 07. 19..
//  Copyright © 2020. Andras Sziffer. All rights reserved.
//

import Foundation
import UIKit

class TabBarController : UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = ChallengeManager.shared.getChallenge()?.name
    }
}
