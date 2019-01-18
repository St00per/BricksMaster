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
    
    var userBricks: [Brick] = [Brick(deviceName: "FirstBrick"), Brick(deviceName: "SecondBrick"), Brick(deviceName: "ThirdBrick")]
    var userBanks: [Bank] = []
    var userPresets: [Preset] = []
        //[Preset(id: 1, name: "First"), Preset(id: 2, name: "Second"), Preset(id: 3, name: "Third"), Preset(id: 4, name: "Fourth")]
    var userFootswitches: [Footswitch] = [Footswitch(id: 0, name: "FirstSwitch"), Footswitch(id: 1, name: "SecondSwitch"), Footswitch(id: 3, name: "ThirdSwitch")]
    
    init() {}
    
}

extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}

