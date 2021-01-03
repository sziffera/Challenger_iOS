//
//  DetailTableViewCell.swift
//  Challenger
//
//  Created by Andras Sziffer on 2020. 10. 07..
//  Copyright © 2020. Andras Sziffer. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {

    @IBOutlet weak var fieldLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
