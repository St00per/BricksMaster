//
//  PresetPickerCollectionViewCell.swift
//  BricksMaster
//
//  Created by Kirill Shteffen on 17/01/2019.
//  Copyright © 2019 BlackBricks. All rights reserved.
//

import UIKit



class PresetPickerCollectionViewCell: UICollectionViewCell {
    
    
    var bank: Bank?
    var preset: Preset?
    var footswitchButtonIndex = 0
    
    
    @IBOutlet weak var presetName: UILabel!
    @IBOutlet weak var bricksIndicatorsView: UIView!
    @IBOutlet weak var selectionMarker: UIImageView!
    
    func configure(preset: Preset) {
        self.preset = preset
        presetName.text = preset.name
        let indicators: [UIView] = bricksIndicatorsView.subviews
        let presetBricks = preset.presetTestBricks
        for indicator in indicators {
            indicator.layer.cornerRadius = indicator.frame.width/2
            indicator.backgroundColor = UIColor.clear
        }
        for index in 0..<presetBricks.count {
            if index < indicators.count, !presetBricks.isEmpty {
                indicators[index].backgroundColor = presetBricks[index].color
            }
        }
        
        if bank?.footswitchButtons[footswitchButtonIndex].preset == preset {
            selectionMarker.image = UIImage(named: "round select")
        } else {
            selectionMarker.image = UIImage(named: "round unselect")
        }
    }
}
