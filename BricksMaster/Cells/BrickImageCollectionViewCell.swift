//
//  BrickImageCollectionViewCell.swift
//  BricksMaster
//
//  Created by Kirill Shteffen on 23/01/2019.
//  Copyright © 2019 BlackBricks. All rights reserved.
//

import UIKit

class BrickImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var brickImage: UIImageView!
    
    func configure(image: UIImage) {
        brickImage.image = image
    }
}
