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
    var brikState: [(Int, Bool)]  = [] // ((int)"brik id from BLE", (Bool)"status: ON / OFF")
    
    init(id: Int) {
        self.id = id
    }
}
