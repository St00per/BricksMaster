//
//  FootswitchBricksCollectionViewCell.swift
//  BricksMaster
//
//  Created by Kirill Shteffen on 24/01/2019.
//  Copyright © 2019 BlackBricks. All rights reserved.
//

import UIKit

class FootswitchBricksCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var brickColorView: UIView!
    @IBOutlet weak var brickImageView: UIImageView!
    
    func configure(brick: Brick) {
        brickColorView.backgroundColor = brick.color
        brickImageView.image = UIImage(named: brick.imageId ?? "")
    }
    
}
