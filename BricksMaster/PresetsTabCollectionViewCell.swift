//
//  PresetsTabCollectionViewCell.swift
//  BricksMaster
//
//  Created by Kirill Shteffen on 17/01/2019.
//  Copyright © 2019 BlackBricks. All rights reserved.
//

import UIKit

class PresetsTabCollectionViewCell: UICollectionViewCell {
    
    var preset: Preset?
    
    @IBOutlet weak var presetName: UILabel!
    
    func configure(preset: Preset) {
        self.preset = preset
        presetName.text = preset.name
    }
    
}
