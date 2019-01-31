//
//  AddBrickPresetCell.swift
//  BricksMaster
//
//  Created by Kirill Shteffen on 25/01/2019.
//  Copyright © 2019 BlackBricks. All rights reserved.
//

import UIKit

class AddBrickPresetCell: UICollectionViewCell {
    
    @IBOutlet weak var addBrickView: UIView!
    
    func configure() {
        addBrickView.addDashedBorder()
    }
}
