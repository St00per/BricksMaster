//
//  Preset.swift
//  DataModel
//
//  Created by Вячеслав Казаков on 14.01.2019.
//  Copyright © 2019 Вячеслав Казаков. All rights reserved.
//

import Foundation
import RealmSwift

class Preset: NSObject {
    var id: String?
    var name: String = "Noname"

    var presetBricks: [(String, Bool)]  = [] // ((int)"brick id from BLE", (Bool)"status: ON / OFF")
    var footswitch: Footswitch?
    
    var presetObject: PresetObject?
    
    override init() {}
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
    
    init(presetObject: PresetObject) {
        self.presetObject = presetObject
        id = presetObject.id
        name = presetObject.name
        for presetBrick in presetObject.presetBricks {
            if let id = presetBrick.brickId {
                presetBricks.append((id, presetBrick.state))
            }
        }
    }
    
    func save() {
        guard let realm = try? Realm() else {
            return
        }
        try! realm.write {
            if let object = presetObject {
                object.update(preset: self)
                realm.add(object, update: true)
            } else {
                let object = PresetObject(preset: self)
                self.presetObject = object
                realm.add(object, update: true)
            }
        }
    }
    
    static func == (lhs: Preset, rhs: Preset) -> Bool {
        return lhs.name == lhs.name
    }
    
    func saveInBackground () {
        DispatchQueue(label: "background").async {
            autoreleasepool {
                self.save()
            }
        }
    }
}
