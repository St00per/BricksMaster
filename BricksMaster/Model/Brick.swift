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
import RealmSwift

enum BrickStatus {
    case on
    case off
}

class Brick: Observable {
    
    var id: String?
    var status: BrickStatus = .off
    var deviceName: String?
    var assignedFootswitch: Footswitch?
    var color = UIColor.white
    //var image: UIImage?
    var imageId: String?
    
    var peripheral: CBPeripheral? = nil
    var tx: CBCharacteristic? = nil
    
    var brickObject: BrickObject?
    
    var new: Bool = true
    
    override func checkConnection() -> Bool {
        isConnected = peripheral != nil && peripheral!.state == .connected && tx != nil
        return isConnected
    }
    
    override func saveConnected() {
        new = false
        save()
    }
    
    override func connect() {
        guard let peripheral = peripheral else { return }
        CentralBluetoothManager.default.centralManager.connect(peripheral, options: nil)
    }
    
    init(deviceName: String) {
        self.deviceName = deviceName
    }
    
    init(id: UUID) {
        self.id = id.uuidString
    }
    
    init(brickObject: BrickObject) {
        super.init()
        self.brickObject = brickObject
        id = brickObject.id
        status = brickObject.status ? .on : .off
        deviceName = brickObject.deviceName
        if let data = brickObject.color {
            color = UIColor.color(withData: data)
        }
        imageId = brickObject.imageId
        new = false
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
    
    func save() {
//        guard let realm = try? Realm() else {
//            return
//        }
//        try! realm.write {
//            if let object = brickObject {
//                object.update(brick: self)
//                realm.add(object, update: true)
//            } else {
//                let object = BrickObject(brick: self)
//                self.brickObject = object
//                realm.add(object)
//            }
//        }
    }
    
//    func saveInBackground () {
//        DispatchQueue(label: "background").async {
//            autoreleasepool {
//                self.save()
//            }
//        }
//    }
}

extension UIColor {
    class func color(withData data:Data) -> UIColor {
        return NSKeyedUnarchiver.unarchiveObject(with: data) as! UIColor
    }
    
    func encode() -> Data {
        return NSKeyedArchiver.archivedData(withRootObject: self)
    }
}
