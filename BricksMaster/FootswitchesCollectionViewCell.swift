//
//  FootswitchesCollectionViewCell.swift
//  BricksMaster
//
//  Created by Kirill Shteffen on 15/01/2019.
//  Copyright © 2019 BlackBricks. All rights reserved.
//

import UIKit

class FootswitchesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var deviceName: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    func configure(footswitch: Footswitch) {
        deviceName.text = footswitch.peripheral?.name
    }
}
