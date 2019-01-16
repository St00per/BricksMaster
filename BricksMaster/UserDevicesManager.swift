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
    var userPresets: [Preset] = []
    var userFootswitches: [Footswitch] = []
    
    init() {}
    
}


