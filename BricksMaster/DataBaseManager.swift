//
//  DataBaseManager.swift
//  BricksMaster
//
//  Created by Вячеслав Казаков on 23.01.2019.
//  Copyright © 2019 BlackBricks. All rights reserved.
//

import Foundation
import RealmSwift

class DataBaseManager {
    
    static let client = DataBaseManager()
    
    func restoreBase()->Bool {
        guard let realm = try? Realm() else {
            return false
        }
        
        let bricks = realm.objects(BrickObject.self)
        let footswitches = realm.objects(FootswitchObject.self)
        let presets = realm.objects(PresetObject.self)
        let banks = realm.objects(BankObject.self)
        
        UserDevicesManager.default.userBricks = bricks.map{ Brick(brickObject: $0) }
        UserDevicesManager.default.userFootswitches = footswitches.map{ Footswitch(footswitchObject: $0) }
        let mappedPresets = presets.map{ Preset(presetObject: $0) }
        let mappedBanks = banks.map{ Bank(bankObject: $0) }
        UserDevicesManager.default.userPresets.append(contentsOf: mappedPresets)

        for bank in mappedBanks {
            if let object = bank.bankObject {
                for presetId in object.presets {
                    if let preset = mappedPresets.first(where: { $0.id == presetId } ) {
                        bank.presets.append( preset )
                    }
                }
            }
        }
        
        for footswitch in UserDevicesManager.default.userFootswitches {
            footswitch.banks = mappedBanks.filter{ $0.footswitchId == footswitch.id }
            footswitch.presets = mappedPresets.filter{ $0.presetObject?.footswitch == footswitch.id}
            footswitch.selectedBank = mappedBanks.first{$0.id == footswitch.footswitchObject?.selectedBank}
            footswitch.selectedPreset = mappedPresets.first{$0.id == footswitch.footswitchObject?.selectedPreset}
            for preset in footswitch.presets {
                preset.footswitch = footswitch
            }
            footswitch.selectedBank = mappedBanks.first{$0.id == footswitch.footswitchObject?.selectedBank}
            footswitch.selectedPreset = mappedPresets.first{$0.id == footswitch.footswitchObject?.selectedPreset}

            if let selectedBank = footswitch.selectedBank {
                for i in 0 ..< selectedBank.footswitchButtons.count {
                    footswitch.buttons[i].index = selectedBank.footswitchButtons[i].index
                    footswitch.buttons[i].isOn = selectedBank.footswitchButtons[i].isOn
                    footswitch.buttons[i].preset = selectedBank.footswitchButtons[i].preset
                }
            }
        }
        
        for brick in UserDevicesManager.default.userBricks {
            brick.assignedFootswitch = UserDevicesManager.default.userFootswitches.first{$0.id == brick.brickObject?.assignedFootswitch}
            brick.assignedFootswitch?.bricks.append(brick)
        }
        
        return true
    }
    
}
