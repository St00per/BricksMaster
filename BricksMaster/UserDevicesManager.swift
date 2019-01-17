//
//  UserDevicesManager.swift
//  BricksMaster
//
//  Created by Kirill Shteffen on 15/01/2019.
//  Copyright © 2019 BlackBricks. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth

class UserDevicesManager {
    
    public static let `default` = UserDevicesManager()
    
    var userBricks: [Brick] = []
    var userBanks: [Bank] = []
    var userPresets: [Preset] = [Preset(id: 1, name: "TestPreset1"),Preset(id: 2, name: "TestPreset2"),Preset(id: 3, name: "TestPreset3")]
    var userFootswitches: [Footswitch] = [Footswitch(id: 0)]
    
    init() {}
    
}


