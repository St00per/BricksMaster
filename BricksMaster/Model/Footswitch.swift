//
//  Footswitch.swift
//  DataModel
//
//  Created by Вячеслав Казаков on 14.01.2019.
//  Copyright © 2019 Вячеслав Казаков. All rights reserved.
//

import Foundation
import CoreBluetooth
import RealmSwift

class Footswitch: Observable {
    
    static let maxBriksCount = 5;
    var id: String?
    var name: String
    var bricks: [Brick] = [Brick]() // bricks assigned to footswitch, applyed presets should be mapped on this
    var buttons: [FootswitchButton] = [FootswitchButton(0), FootswitchButton(1), FootswitchButton(2), FootswitchButton(3)]
    var customButton: CustomButton = CustomButton()
    var selectedBank: Bank?
    var banks: [Bank] = []
    var presets: [Preset] = []
    var selectedPreset: Preset?
    
    var peripheral: CBPeripheral? = nil
    var tx: CBCharacteristic? = nil
    var rx: CBCharacteristic? = nil
    var needInitalizePorts: Bool = true
    
    var footswitchObject: FootswitchObject?
    
    var new: Bool = true
    
    override func checkConnection() -> Bool {
        isConnected = peripheral != nil && peripheral!.state == .connected && tx != nil && rx != nil
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
    
    init(id: String?, name: String) {
        self.id = id
        self.name = name
        super.init()
        
        self.banks = [Bank(id: UUID().uuidString, name: "")]
        for bank in self.banks {
            bank.footswitchId = self.id
        }
        banks.first?.name = "Default bank"
        banks.first?.empty = false
        customButton.footswitch = self
        selectedBank = banks.first

        //TODO: REMOVE ON RELEASE
        //self.mockData()
    }
    
    init(footswitchObject: FootswitchObject) {
        id = footswitchObject.id
        name = footswitchObject.name ?? ""
        super.init()
        self.new = false
        self.footswitchObject = footswitchObject
        
        let emptyBanksCount = 4 - banks.count
    }
    
    
    func selectBank( bank: Bank ) {
        selectedBank = bank
        selectedPreset = nil
        for (index, preset) in bank.presets.enumerated() {
            buttons[index].preset = preset
            buttons[index].isOn = false
        }
    }
    
    static func == (lhs: Footswitch, rhs: Footswitch) -> Bool {
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
    
    
    func mockBanks() -> [Bank] {
        return [Bank(id: UUID().uuidString ,name: "TestBank1")];
    }
    
    func mockData() {
        banks.append(contentsOf: [Bank(id: UUID().uuidString ,name: "TestBank1")])
        presets.append(contentsOf: [Preset(id: UUID().uuidString, name: "First"), Preset(id: UUID().uuidString, name: "Second"), Preset(id: UUID().uuidString, name: "Third"), Preset(id: UUID().uuidString, name: "Fourth")])
    }
    
    func save() {
//        guard let realm = try? Realm() else {
//            return
//        }
//        do {
//        try realm.write {
//        if let object = footswitchObject {
//            object.update(footswitch: self)
//            realm.add(object, update: true)
//        } else {
//            let object = FootswitchObject(footswitch: self)
//            self.footswitchObject = object
//            realm.add(object, update: true)
//        }
//            
//        }
//        } catch {
//            println(error)
//        }
    }
    
    func saveInBackground() {
        DispatchQueue(label: "background").async {
            autoreleasepool {
                self.save()
            }
        }
    }
}
