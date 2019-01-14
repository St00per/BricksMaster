//
//  Brick.swift
//  DataModel
//
//  Created by Вячеслав Казаков on 14.01.2019.
//  Copyright © 2019 Вячеслав Казаков. All rights reserved.
//

import Foundation

enum BrickStatus {
    case on
    case off
}

class Brick {
    var id: Int
    var status: BrickStatus = .off
    
    init(id: Int) {
        self.id = id
    }
}
