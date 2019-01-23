//
//  SectionHeaderView.swift
//  BricksMaster
//
//  Created by Kirill Shteffen on 22/01/2019.
//  Copyright © 2019 BlackBricks. All rights reserved.
//

import UIKit

class SectionHeaderView: UICollectionReusableView {
    
    @IBOutlet weak var footswitchTitleLabel: UILabel!
    
    var footswitchName: String! {
        didSet {
            footswitchTitleLabel.text = footswitchName
        }
    }
}
