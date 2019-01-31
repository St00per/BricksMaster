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
    
    @IBOutlet weak var brickColorView: UIView!
    
    @IBOutlet weak var brickImageView: UIImageView!
    
    @IBOutlet weak var brickSelectionMark: UIImageView!
    
    func configure(brick: Brick, currentPreset: Preset, appendedBricks: [Brick]) {
        brickName.text = brick.deviceName
        brickColorView.backgroundColor = brick.color
        brickColorView.dropShadow()
        brickImageView.image = UIImage(named: brick.imageId ?? "")
        
        if appendedBricks.contains(brick) {
            brickSelectionMark.image = UIImage(named: "Select")
        } else {
            brickSelectionMark.image = UIImage(named: "Unselect")
        }
    }
    
    
}
