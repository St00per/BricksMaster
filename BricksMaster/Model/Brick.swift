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
    
    var isConnected: Bool {
        get {
            guard let peripheral = peripheral else {
                return false
            }
            return peripheral.state == .connected
        }
    }
    
    var observers: [ConnectionObserver] = []
    
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
    
    func subscribe(observer: ConnectionObserver) {
        observers.append(observer)
    }
    
    func unsubscribe(observer: ConnectionObserver) {
        if let index = observers.firstIndex (where: { (findedObserver) -> Bool in
            let findedObserver = findedObserver as? NSObject
            let observer = observer as? NSObject
            return findedObserver == observer
            })
        {
            observers.remove(at: index)
        }
    }
}
