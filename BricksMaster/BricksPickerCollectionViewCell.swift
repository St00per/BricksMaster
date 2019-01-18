//
//  BricksPickerCollectionViewCell.swift
//  BricksMaster
//
//  Created by Kirill Shteffen on 17/01/2019.
//  Copyright © 2019 BlackBricks. All rights reserved.
//

import UIKit

class BricksPickerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var brickName: UILabel!
    
    func configure(brick: Brick) {
        brickName.text = brick.deviceName
    }
    
}
