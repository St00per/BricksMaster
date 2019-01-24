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
    var presets: [Preset] = [] // presets according to order 1st button - 1st preset
    var footswitchId: String?
    var footswitchButtons: [FootswitchButton] = [FootswitchButton(0), FootswitchButton(1), FootswitchButton(2), FootswitchButton(3)]
    
    var bankObject: BankObject?
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
    
    init(bankObject: BankObject) {
        self.bankObject = bankObject
        id = bankObject.id
        name = bankObject.name
        footswitchId = bankObject.footswitchId
        for (i, button) in bankObject.footswitchButtons.enumerated() {
            footswitchButtons[i].id = button.id
            footswitchButtons[i].index = button.index
            footswitchButtons[i].isOn = button.isOn
        }
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
                realm.add(object)
                }
        }
    }
}
