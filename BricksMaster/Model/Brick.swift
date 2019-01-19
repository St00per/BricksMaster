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
    
    var id: UUID?
    var peripheral: CBPeripheral? = nil
    var status: BrickStatus = .off
    var deviceName: String?
    var color = UIColor.lightGray
    var tx: CBCharacteristic?
    
    init(deviceName: String) {
        self.deviceName = deviceName
    }
    
    init(id: UUID) {
        self.id = id
    }
    
    static func == (lhs: Brick, rhs: Brick) -> Bool {
        guard let first = lhs.peripheral, let second = rhs.peripheral else {
            return false
        }
        return first.identifier == second.identifier
    }
    
    
}
