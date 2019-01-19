//
//  FootswitchPickerCollectionViewCell.swift
//  BricksMaster
//
//  Created by Kirill Shteffen on 17/01/2019.
//  Copyright © 2019 BlackBricks. All rights reserved.
//

import UIKit

class FootswitchPickerCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var footswitchName: UILabel!
    
    func configure(footswitch: Footswitch) {
        footswitchName.text = footswitch.name
    }
    
}
