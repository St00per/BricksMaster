//
//  BrickImageCollectionViewCell.swift
//  BricksMaster
//
//  Created by Kirill Shteffen on 23/01/2019.
//  Copyright © 2019 BlackBricks. All rights reserved.
//

import UIKit

class BrickImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var brickColorView: UIView!
    @IBOutlet weak var brickImage: UIImageView!
    @IBOutlet weak var selectedImageView: UIImageView!
    
    @IBOutlet weak var width: NSLayoutConstraint!
    @IBOutlet weak var height: NSLayoutConstraint!
    
    
    func configure(image: UIImage, color: UIColor) {
        brickImage.image = image
        brickColorView.backgroundColor = color
    }
    
    override var isSelected: Bool {
        didSet {
            selectedImageView.isHidden = !isSelected
            self.alpha = isSelected ? 1 : 0.5
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            selectedImageView.isHidden = !isHighlighted
        }
    }
}
