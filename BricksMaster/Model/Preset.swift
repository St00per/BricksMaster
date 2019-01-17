//
//  Preset.swift
//  DataModel
//
//  Created by Вячеслав Казаков on 14.01.2019.
//  Copyright © 2019 Вячеслав Казаков. All rights reserved.
//

import Foundation

class Preset {
    var id: Int
    var name: String?
    var bricksState: [(Int, Bool)]  = [] // ((int)"brick id from BLE", (Bool)"status: ON / OFF")
    var footswitch: Footswitch?
    
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}
