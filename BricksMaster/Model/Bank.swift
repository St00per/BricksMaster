//
//  Bank.swift
//  DataModel
//
//  Created by Вячеслав Казаков on 14.01.2019.
//  Copyright © 2019 Вячеслав Казаков. All rights reserved.
//

import Foundation

class Bank {
    var id: Int
    var name: String?
    var presets: [Preset] = [] // presets according to order 1st button - 1st preset
    var footswitchId: UUID?
    var footswitchButtons: [FootswitchButton] = [FootswitchButton(0), FootswitchButton(1), FootswitchButton(2), FootswitchButton(3)]
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}
