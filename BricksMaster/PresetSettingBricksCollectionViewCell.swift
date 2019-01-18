//
//  PresetSettingBricksCollectionViewCell.swift
//  BricksMaster
//
//  Created by Kirill Shteffen on 17/01/2019.
//  Copyright © 2019 BlackBricks. All rights reserved.
//

import UIKit



class PresetSettingBricksCollectionViewCell: UICollectionViewCell {
    
    var brickIndex: Int = 0
    
    var isBrickOn: Bool = false
    
    var viewController: PresetSettingViewController?
    
    
    @IBOutlet weak var brickName: UILabel!
    
    @IBOutlet weak var presetBrickOnOffButton: UIButton!
    
    @IBAction func changePresetBrickState(_ sender: UIButton) {
        
    }
    
    @IBAction func removeBrickFromPreset(_ sender: UIButton) {
        UserDevicesManager.default.userPresets[0].presetBricks.remove(at: brickIndex)
        guard let presetBricksCollectionView = viewController?.presetBricksCollectionView else { return }
        presetBricksCollectionView.reloadData()
    }
    
    func configure(brick: Brick, index: Int) {
        brickName.text = brick.deviceName
        brickIndex = index
        
    }
    
}
