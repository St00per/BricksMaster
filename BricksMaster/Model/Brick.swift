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

class Brick: Observable {
    
    var id: UUID?
    var peripheral: CBPeripheral? = nil
    var status: BrickStatus = .off
    var deviceName: String?
    var assignedFootswitch: Footswitch?
    var color = UIColor.lightGray
    var image: UIImage?
    var tx: CBCharacteristic?
    
    var isConnected: Bool {
        get {
            guard let peripheral = peripheral else {
                return false
            }
            return peripheral.state == .connected
        }
    }
    
    
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
    
    func updateConnection(isConnected: Bool) {
        for observer in observers {
            if let id = peripheral?.identifier {
                observer.brickConnectionStateChanged(connected: isConnected, peripheralId: id)
            }
        }
    }
}
