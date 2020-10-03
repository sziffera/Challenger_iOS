//
//  SelfSizedTableView.swift
//  Challenger
//
//  Created by Andras Sziffer on 2020. 08. 25..
//  Copyright © 2020. Andras Sziffer. All rights reserved.
//

import UIKit

class SelfSizedTableView: UITableView {

      var maxHeight: CGFloat = UIScreen.main.bounds.size.height
      
      override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
        self.layoutIfNeeded()
      }
      
      override var intrinsicContentSize: CGSize {
        let height = min(contentSize.height, maxHeight)
        return CGSize(width: contentSize.width, height: height)
      }

}
