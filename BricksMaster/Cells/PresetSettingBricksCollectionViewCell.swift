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
    var preset: Preset? = nil
    var isBrickOn: Bool = false
    
    var viewController: PresetSettingViewController?
    
    
    @IBOutlet weak var brickName: UILabel!
    
    @IBOutlet weak var presetBrickOnOffButton: UIButton!
    
    @IBAction func changePresetBrickState(_ sender: UIButton) {
        if preset?.presetBricks[brickIndex].1 == false {
            preset?.presetBricks[brickIndex].1 = true
            presetBrickOnOffButton.setTitle("ON", for: .normal)
            presetBrickOnOffButton.backgroundColor = UIColor.black
        } else {
            preset?.presetBricks[brickIndex].1 = false
            presetBrickOnOffButton.setTitle("OFF", for: .normal)
            presetBrickOnOffButton.backgroundColor = UIColor(hexString: "EDEDED")
        }
    }
    
    @IBAction func removeBrickFromPreset(_ sender: UIButton) {
        preset?.presetBricks.remove(at: brickIndex)
        guard let presetBricksCollectionView = viewController?.presetBricksCollectionView else { return }
        presetBricksCollectionView.reloadData()
    }
    
    func configure(brick: Brick, index: Int) {
        brickName.text = brick.deviceName
        brickIndex = index
        if preset?.presetBricks[brickIndex].1 == false {
            presetBrickOnOffButton.setTitle("OFF", for: .normal)
            presetBrickOnOffButton.backgroundColor = UIColor(hexString: "EDEDED")
        } else {
            presetBrickOnOffButton.setTitle("ON", for: .normal)
            presetBrickOnOffButton.backgroundColor = UIColor.black
        }
    }
    
}
