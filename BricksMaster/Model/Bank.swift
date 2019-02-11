//
//  Bank.swift
//  DataModel
//
//  Created by Вячеслав Казаков on 14.01.2019.
//  Copyright © 2019 Вячеслав Казаков. All rights reserved.
//

import Foundation
import RealmSwift

class Bank {
    var id: String?
    var name: String?
    var presets: [Preset] = [Preset(),Preset(),Preset(),Preset()] // presets according to order 1st button - 1st preset
    var footswitchId: String?
    
    
    var empty: Bool = true
    
    var bankObject: BankObject?
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
    
    init(bankObject: BankObject) {
        self.bankObject = bankObject
        id = bankObject.id
        name = bankObject.name
        for index in 0..<bankObject.presets.count {
            presets[index].id = bankObject.presets[index]
        }
        empty = false
        footswitchId = bankObject.footswitchId
        empty = bankObject.empty
    }

    func save() {
        guard let realm = try? Realm() else {
            return
        }
        try! realm.write {
            if let object = bankObject {
                object.update(bank: self)
                realm.add(object, update: true)
            } else {
                let object = BankObject(bank: self)
                self.bankObject = object
                realm.add(object)
                }
        }
    }
    
    func saveInBackground () {
        DispatchQueue(label: "background").async {
            autoreleasepool {
                self.save()
            }
        }
    }
    
    
}
