//
//  PresetPickerCollectionViewCell.swift
//  BricksMaster
//
//  Created by Kirill Shteffen on 17/01/2019.
//  Copyright © 2019 BlackBricks. All rights reserved.
//

import UIKit



class PresetPickerCollectionViewCell: UICollectionViewCell {
    
    var preset: Preset?
    var controller: PresetPickerViewController?
    var footswitchButtonIndex = 0
    
    @IBOutlet weak var presetName: UILabel!
    @IBAction func setPresetToFootswitchButton(_ sender: UIButton) {
        guard let selectedPreset = preset else { return }
        UserDevicesManager.default.userFootswitches[0].buttons[footswitchButtonIndex].preset = selectedPreset
        controller?.dismiss(animated: true, completion: nil)
    }
    
    func configure(preset: Preset) {
        self.preset = preset
        presetName.text = preset.name
    }
    
}
