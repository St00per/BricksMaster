//
//  Footswitch.swift
//  DataModel
//
//  Created by Вячеслав Казаков on 14.01.2019.
//  Copyright © 2019 Вячеслав Казаков. All rights reserved.
//

import Foundation

class Footswitch {
    static let maxBriksCount = 5;
    var id: Int
    var bricks: [Brick] = [Brick]() // bricks assigned to footswitch, applyed presets should be mapped on this
    var buttons: [FootswitchButton] = [FootswitchButton(0), FootswitchButton(1), FootswitchButton(2), FootswitchButton(3)]
    var customButton: CustomButton = CustomButton()
    var selectedBank: Bank?
    var selectedPreset: Preset?
    
    init(id: Int) {
        self.id = id
    }
    
    func selectBank( bank: Bank ) {
        selectedBank = bank
        selectedPreset = nil
        for (index, preset) in bank.presets.enumerated() {
            buttons[index].preset = preset
            buttons[index].isSelected = false
        }
    }
}
