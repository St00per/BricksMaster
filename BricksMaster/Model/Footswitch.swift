//
//  Footswitch.swift
//  DataModel
//
//  Created by Вячеслав Казаков on 14.01.2019.
//  Copyright © 2019 Вячеслав Казаков. All rights reserved.
//

import Foundation
import CoreBluetooth

class Footswitch: Equatable {
    
    static let maxBriksCount = 5;
    var id: UUID
    var name: String
    var bricks: [Brick] = [Brick]() // bricks assigned to footswitch, applyed presets should be mapped on this
    var buttons: [FootswitchButton] = [FootswitchButton(0), FootswitchButton(1), FootswitchButton(2), FootswitchButton(3)]
    var customButton: CustomButton = CustomButton()
    var selectedBank: Bank?
    var selectedPreset: Preset?
    var peripheral: CBPeripheral? = nil
    var characteristic: CBCharacteristic?
    init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }
    
    func selectBank( bank: Bank ) {
        selectedBank = bank
        selectedPreset = nil
        for (index, preset) in bank.presets.enumerated() {
            buttons[index].preset = preset
            buttons[index].isOn = false
        }
    }
    
    static func == (lhs: Footswitch, rhs: Footswitch) -> Bool {
        guard let first = lhs.peripheral, let second = rhs.peripheral else {
            return false
        }
        return first.identifier == second.identifier
    }
    
}
