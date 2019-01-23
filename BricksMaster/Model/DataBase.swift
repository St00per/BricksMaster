//
//  DataBase.swift
//  BricksMaster
//
//  Created by Вячеслав Казаков on 23.01.2019.
//  Copyright © 2019 BlackBricks. All rights reserved.
//

import Foundation
import RealmSwift

class BankObject: Object {
    @objc dynamic var id: String?
    @objc dynamic var name: String?
    var presets: List<String> = List<String>() // presets according to order 1st button - 1st preset
    @objc dynamic var footswitchId: String?
    var footswitchButtons: List<FootswitchButtonObject> = List<FootswitchButtonObject>()
    
    convenience init(bank: Bank) {
        self.init()
        self.update(bank: bank)
    }
    
    func update(bank: Bank) {
        self.id = bank.id
        self.name = bank.name
        self.presets.removeAll()
        for preset in bank.presets {
            if let id = preset.id {
                self.presets.append(id)
            }
        }
        self.footswitchId = bank.footswitchId
        for button in bank.footswitchButtons {
            self.footswitchButtons.append(FootswitchButtonObject(footswitchButton: button))
        }
    }
}

class BrickStateObject: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var brickId: String?
    @objc dynamic var state: Bool = false
    
    convenience init(id: String, state: Bool) {
        self.init()
        self.id = id
        self.state = state
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

class PresetObject: Object {
    @objc dynamic var id: String?
    @objc dynamic var name: String = "Unnamed"
    var presetBricks: List<BrickStateObject>  = List<BrickStateObject>()
    @objc dynamic var footswitch: String?
    
    
    convenience init(preset: Preset) {
        self.init()
        self.update(preset: preset)
    }
    
    func update(preset: Preset) {
        self.id = preset.id
        self.name = preset.name
        presetBricks.removeAll()
        for presetState in preset.presetBricks {
            presetBricks.append(BrickStateObject(id: presetState.0, state: presetState.1))
        }
        footswitch = preset.footswitch?.id
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

class FootswitchObject: Object {
    @objc dynamic var id: String?
    @objc dynamic var name: String?
    var bricks: List<String> = List<String>()
    var buttons: List<FootswitchButtonObject> = List<FootswitchButtonObject>()
    @objc dynamic var selectedBank: String?
    var banks: List<String> = List<String>()
    var presets: List<String> = List<String>()
    @objc dynamic var selectedPreset: String?
    
    convenience init(footswitch: Footswitch) {
        self.init()
        self.update(footswitch: footswitch)
    }
    
    func update(footswitch: Footswitch) {
        self.id = footswitch.id
        self.name = footswitch.name
        self.bricks.removeAll()
        for brick in footswitch.bricks {
            if let id = brick.id {
                self.bricks.append(id)
            }
        }
        self.buttons.removeAll()
        for button in footswitch.buttons {
            self.buttons.append(FootswitchButtonObject(footswitchButton: button))
        }
        if let selectedBank = footswitch.selectedBank {
            self.selectedBank = selectedBank.id
        }
        banks.removeAll()
        for bank in footswitch.banks {
            if let id = bank.id {
                banks.append(id)
            }
        }
        presets.removeAll()
        for preset in footswitch.presets {
            if let id = preset.id {
                presets.append(id)
            }
        }
        self.selectedPreset = footswitch.selectedPreset?.id
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

class BrickObject: Object {
    @objc dynamic var id: String?
    @objc dynamic var status: Bool = false
    @objc dynamic var deviceName: String?
    @objc dynamic var color: Data?
    @objc dynamic var imageId: String?
    @objc dynamic var assignedFootswitch: String?
    
    convenience init(brick: Brick) {
        self.init()
        self.update(brick: brick)
    }
    
    func update(brick: Brick) {
        self.id = brick.id
        self.color = brick.color.encode()
        self.deviceName = brick.deviceName
        self.status = brick.status == .on
        self.imageId = brick.imageId
        self.assignedFootswitch = brick.assignedFootswitch?.id
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    
}

class FootswitchButtonObject: Object {
    @objc dynamic var id: String!
    @objc dynamic var index: Int = -1
    @objc dynamic  var preset: String?
    @objc dynamic var isOn: Bool = false
    
    convenience init(footswitchButton: FootswitchButton) {
        self.init()
        self .update(footswitchButton: footswitchButton)
    }
    
    func update(footswitchButton: FootswitchButton) {
        self.id = footswitchButton.id
        self.index = footswitchButton.index
        if let preset = footswitchButton.preset {
            if let id = preset.id {
                self.preset = id
            }
        }
        self.isOn = footswitchButton.isOn
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
