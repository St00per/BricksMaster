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
    
    init(id: Int) {
        self.id = id
    }
}
