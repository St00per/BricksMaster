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
    var footswitch: Footswitch?
    
    func configure(footswitch: Footswitch) {
        deviceName.text = footswitch.peripheral?.name
        self.footswitch = footswitch
    }
    
    @IBAction func connect(_ sender: Any?) {
        guard let footswitch = footswitch, let peripheral = footswitch.peripheral else {
           return
        }
        CentralBluetoothManager.default.connect(peripheral: peripheral)
    }
}
