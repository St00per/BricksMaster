//
//  Brick.swift
//  DataModel
//
//  Created by Вячеслав Казаков on 14.01.2019.
//  Copyright © 2019 Вячеслав Казаков. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth

enum BrickStatus {
    case on
    case off
}

class Brick: Equatable {
    var id: Int
    var status: BrickStatus = .off
    
    init(id: Int) {
        self.id = id
    }
    
    static func == (lhs: Brick, rhs: Brick) -> Bool {
        guard let first = lhs.peripheral, let second = rhs.peripheral else {
            return false
        }
        return first.identifier == second.identifier
    }
    
    var peripheral: CBPeripheral? = nil
    var color = UIColor.lightGray
    
}
