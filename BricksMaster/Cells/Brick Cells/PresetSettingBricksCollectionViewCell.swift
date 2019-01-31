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
    @IBOutlet weak var brickColor: UIView!
    @IBOutlet weak var brickImage: UIImageView!
    
    @IBOutlet weak var presetBrickOnOffButton: UIButton!
    
    @IBAction func changePresetBrickState(_ sender: UIButton) {
        
        if preset?.presetTestBricks[brickIndex].status == .off {
            preset?.presetTestBricks[brickIndex].status = .on
            presetBrickOnOffButton.setTitle("ON", for: .normal)
            presetBrickOnOffButton.backgroundColor = UIColor(hexString: "94C15B")
        } else {
            preset?.presetTestBricks[brickIndex].status = .off
            presetBrickOnOffButton.setTitle("OFF", for: .normal)
            presetBrickOnOffButton.backgroundColor = UIColor(hexString: "DE6969")
        }
        
//        if preset?.presetBricks[brickIndex].1 == false {
//            preset?.presetBricks[brickIndex].1 = true
//            presetBrickOnOffButton.setTitle("ON", for: .normal)
//            presetBrickOnOffButton.backgroundColor = UIColor(hexString: "94C15B")
//        } else {
//            preset?.presetBricks[brickIndex].1 = false
//            presetBrickOnOffButton.setTitle("OFF", for: .normal)
//            presetBrickOnOffButton.backgroundColor = UIColor(hexString: "DE6969")
//        }
    }
    
    @IBAction func removeBrickFromPreset(_ sender: UIButton) {
        preset?.presetTestBricks.remove(at: brickIndex)
        guard let presetBricksCollectionView = viewController?.presetBricksCollectionView else { return }
        presetBricksCollectionView.reloadData()
    }
    
    func configure(brick: Brick, index: Int) {
        brickName.text = brick.deviceName
        brickIndex = index
        brickColor.backgroundColor = brick.color
        brickImage.image = UIImage(named: brick.imageId ?? "")
        if preset?.presetTestBricks[brickIndex].status == .off {
            presetBrickOnOffButton.setTitle("OFF", for: .normal)
            presetBrickOnOffButton.backgroundColor = UIColor(hexString: "DE6969")
        } else {
            presetBrickOnOffButton.setTitle("ON", for: .normal)
            presetBrickOnOffButton.backgroundColor = UIColor(hexString: "94C15B")
        }
    }
    
}
