//
//  PresetPickerCollectionViewCell.swift
//  BricksMaster
//
//  Created by Kirill Shteffen on 17/01/2019.
//  Copyright © 2019 BlackBricks. All rights reserved.
//

import UIKit



class PresetPickerCollectionViewCell: UICollectionViewCell {
    
    var footswitch: Footswitch?
    var bank: Bank?
    var preset: Preset?
    var controller: PresetPickerViewController?
    var footswitchButtonIndex = 0
    
    
    @IBOutlet weak var presetName: UILabel!
    @IBAction func setPresetToFootswitchButton(_ sender: UIButton) {
        guard let selectedPreset = preset else { return }
        
        let footswitchArray = UserDevicesManager.default.userFootswitches
        guard let currentFootswitch = self.footswitch, let currentBank = self.bank else { return }
        guard let footswitchIndex = footswitchArray.firstIndex(of: currentFootswitch) else { return }
       
        let bank = UserDevicesManager.default.userFootswitches[footswitchIndex].banks.first{$0.id == currentBank.id}
        if let bank = bank {
            bank.footswitchButtons[footswitchButtonIndex].preset = selectedPreset
        }
        bank?.saveInBackground()
        currentFootswitch.saveInBackground()
        controller?.dismiss(animated: true, completion: nil)
    }
    
    func configure(preset: Preset) {
        self.preset = preset
        presetName.text = preset.name
    }
    
}
