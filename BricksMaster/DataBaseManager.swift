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
        
        for footswitch in UserDevicesManager.default.userFootswitches {
            footswitch.banks = mappedBanks.filter{ $0.footswitchId == footswitch.id }
            footswitch.presets = mappedPresets.filter{ $0.presetObject?.footswitch == footswitch.id}
            footswitch.selectedBank = mappedBanks.first{$0.id == footswitch.footswitchObject?.selectedBank}
            footswitch.selectedPreset = mappedPresets.first{$0.id == footswitch.footswitchObject?.selectedPreset}
        }
        
        for brick in UserDevicesManager.default.userBricks {
            brick.assignedFootswitch = UserDevicesManager.default.userFootswitches.first{$0.id == brick.brickObject?.assignedFootswitch}
            brick.assignedFootswitch?.bricks.append(brick)
        }
        
        return true
    }
    
}
