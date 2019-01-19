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
        //[Preset(id: 1, name: "First"), Preset(id: 2, name: "Second"), Preset(id: 3, name: "Third"), Preset(id: 4, name: "Fourth")]
    var userFootswitches: [Footswitch] = []
    
    var footswitchController: FootswitchEditViewController? = nil
    
    init() {}
    
    func footswitchByPeripheral(peripheral: CBPeripheral) -> Footswitch? {
        for footswitch in userFootswitches {
            if footswitch.peripheral == peripheral {
                return footswitch
            }
        }
        return nil
    }
    
    func brickForPeripheral(peripheral: CBPeripheral) -> Brick? {
        for footswitch in userBricks {
            if footswitch.peripheral == peripheral {
                return footswitch
            }
        }
        return nil
    }
    
    func updateFootswitch(footswitch: Footswitch) {
        guard let controller = footswitchController else {
            return
        }
        if controller.currentFootswitch == footswitch {
            controller.configurePresetButtons()
        }
    }
    
    func sendPreset(preset:Preset, to footswitch: Footswitch) {
        for brickState in preset.presetBricks {
            if let currentBrick = brick(id: brickState.0), let peripheral = currentBrick.peripheral, let tx = currentBrick.tx {
                //TODO: send it to proper characteristic
                var dataToWrite = Data()
                dataToWrite.append(0xE7)
                dataToWrite.append(0xF1)
                if brickState.1 {
                    dataToWrite.append(0x01)
                } else {
                    dataToWrite.append(0x00)

                }
                CentralBluetoothManager.default.sendCommand(to: peripheral, characteristic: tx, data: dataToWrite)
            }
        }
    }
    
    func banks(footswitch: Footswitch) {
        
    }
    
    func footswitch(id: UUID)  -> Footswitch?{
        for footswitch in userFootswitches {
            if footswitch.id == id {
                return footswitch
            }
        }
        return nil
    }
    
    func preset(id: Int) -> Preset? {
        for preset in userPresets {
            if preset.id == id {
                return preset
            }
        }
        return nil
    }
    
    func brick(id: UUID) -> Brick? {
        for brick in userBricks {
            if brick.id == id {
                return brick
            }
        }
        return nil
    }
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

