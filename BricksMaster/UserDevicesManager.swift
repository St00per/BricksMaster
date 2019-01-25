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
    
    var userBricks: [Brick] = [Brick(deviceName: "Test1"), Brick(deviceName: "Test2"), Brick(deviceName: "Test3"), Brick(deviceName: "Test4"), Brick(deviceName: "Test5")]
    var userPresets: [Preset] = []
    var userFootswitches: [Footswitch] = [Footswitch(id: "1", name: "TestFoot1"), Footswitch(id: "2", name: "TestFoot2"), Footswitch(id: "3", name: "TestFoot3")]
    
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
        if let controller = footswitchController  {
            if controller.currentFootswitch == footswitch {
                controller.configurePresetButtons()
            }
        }
        if let preset = footswitch.selectedPreset {
            sendPreset(preset: preset, to: footswitch)
        }
    }
    
    func sendPreset(preset:Preset, to footswitch: Footswitch) {
        println("Send preset: \(preset.name)")
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
                println("Set brick(\(peripheral.name ?? "noname")/\(peripheral.identifier)) state: \(brickState.1)")
                CentralBluetoothManager.default.sendCommand(to: peripheral, characteristic: tx, data: dataToWrite)
            }
        }
        for i in 0...3 {
            lightButton(id: i, to: footswitch, on: footswitch.buttons[i].isOn)
        }
    }
    
    func disableAll(footSwitch: Footswitch) {
        for currentBrick in footSwitch.bricks {
            if let peripheral = currentBrick.peripheral, let tx = currentBrick.tx {
                //TODO: send it to proper characteristic
                var dataToWrite = Data()
                dataToWrite.append(0xE7)
                dataToWrite.append(0xF1)
                dataToWrite.append(0x00)
                println("Disable brick(\(peripheral.name ?? "noname")/\(peripheral.identifier))")
                CentralBluetoothManager.default.sendCommand(to: peripheral, characteristic: tx, data: dataToWrite)
            }
        }
    }
    
    func nextBank(footswitch: Footswitch) {
        if let selectedBank = footswitch.selectedBank {
            if let index = footswitch.banks.firstIndex(where: { (bank) -> Bool in
                return bank.id == selectedBank.id
            }) {
                var nextBank: Bank?
                var currentIndex: Int?
                for i in 1 ..< 4 {
                    let next = (index + i) % 4
                     nextBank = footswitch.banks[next]
                    if let nextBank = nextBank {
                        if !nextBank.empty {
                            currentIndex = next
                            break
                        }
                    }
                }
                if let nextBank = nextBank {
                    footswitch.selectedBank = nextBank
                }
                print("Next bank \(nextBank?.name)")
                if let controller = footswitchController  {
                    if controller.currentFootswitch == footswitch {
                        if let nextBank = nextBank, let index = currentIndex {
                        controller.newBankSelected(bank: nextBank, index: index)
                        }
                    }
                }
                if let preset = nextBank?.presets.first {
                    sendPreset(preset: preset, to: footswitch)
                }
            }
        } else {
            
        }
    }
    
    func lightButton(id: Int, to footswitch: Footswitch, on: Bool) {
        guard  let peripheral = footswitch.peripheral, let tx = footswitch.tx else {
            return
        }
        // Write value
        let map = [10, 21, 22, 23]
        let index = map[id];
        let port = UInt8(index / 8)
        let data0 = 0x90 + port
        
        let offset = 8 * Int(port)
        var state: Int = 0
        for i in 0...7 {
            var pinValue = 1
            if(i+offset>9) {
                if(i == index - offset) {
                    pinValue = on ? 0x1 : 0x0
                } else {
                    pinValue = 0x0
                }
            }
            let pinMask = pinValue << i
            state |= pinMask
        }
    
        let data1 = UInt8(state & 0x7f)         // only 7 bottom bits
        let data2 = UInt8(state >> 7)           // top bit in second byte
    
        let bytes: [UInt8] = [data0, data1, data2]
        let data = Data(bytes: bytes)
        println("Light (\(peripheral.name ?? "noname")/\(peripheral.identifier)) state: \(index)")
        CentralBluetoothManager.default.sendCommand(to: peripheral, characteristic: tx, data: data)
    }
    
    func banks(footswitch: Footswitch) {
        
    }
    
    func footswitch(id: String)  -> Footswitch?{
        for footswitch in userFootswitches {
            if footswitch.id == id {
                return footswitch
            }
        }
        return nil
    }
    
    func preset(id: String) -> Preset? {
        for preset in userPresets {
            if preset.id == id {
                return preset
            }
        }
        return nil
    }
    
    func brick(id: String) -> Brick? {
        for brick in userBricks {
            if brick.id == id {
                return brick
            }
        }
        return nil
    }
    
    func enableBrick(brick: Brick, isEnabled: Bool) {
        guard let switchedBrick = userBricks.first(where: {brick == $0}) else { return }
        let brickTx = CentralBluetoothManager.default.bricksCharacteristic
        if let peripheral = switchedBrick.peripheral, let tx = brickTx {
            var dataToWrite = Data()
            dataToWrite.append(0xE7)
            dataToWrite.append(0xF1)
            if brick.status == .on {
                dataToWrite.append(0x01)
            } else {
                dataToWrite.append(0x00)
                
            }
            println("Set brick(\(peripheral.name ?? "noname")/\(peripheral.identifier)) state: \(brick.status == .on)")
            CentralBluetoothManager.default.sendCommand(to: peripheral, characteristic: tx, data: dataToWrite)
        }
    }
    
    func connect(brick: Brick) {
//        if(CentralBluetoothManager.default.connectQueue.count > 0) {
//            CentralBluetoothManager.default.connectQueue.append(brick)
//        } else {
            CentralBluetoothManager.default.connectQueue.append(brick)
            brick.connect()
//        }
    }
    
    func connect(footswitch: Footswitch) {
        if(CentralBluetoothManager.default.connectQueue.count > 0) {
            CentralBluetoothManager.default.connectQueue.append(footswitch)
        } else {
            CentralBluetoothManager.default.connectQueue.append(footswitch)
            footswitch.connect()
        }
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

extension UIView {
    
    func addDashedBorder() {
        let color = UIColor.lightGray.cgColor
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 1
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [3,3]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 5).cgPath
        
        self.layer.addSublayer(shapeLayer)
    }
}
