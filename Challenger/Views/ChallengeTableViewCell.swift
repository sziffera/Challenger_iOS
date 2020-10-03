//
//  ChallengeTableViewCell.swift
//  Challenger
//
//  Created by Andras Sziffer on 2020. 08. 23..
//  Copyright © 2020. Andras Sziffer. All rights reserved.
//

import UIKit
import SwipeCellKit
class ChallengeTableViewCell: SwipeTableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var challengeTypeImageView: UIImageView!

    
    @IBOutlet weak var myContentView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //myContentView.layer.cornerRadius = 15
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //adding margins to cells in TableView
        let margins = UIEdgeInsets(top: 2, left: 10, bottom: 2, right: 10)
        contentView.frame = contentView.frame.inset(by: margins)
    }
}
