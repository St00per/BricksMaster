//
//  BricksCollectionViewCell.swift
//  BricksMaster
//
//  Created by Kirill Shteffen on 15/01/2019.
//  Copyright © 2019 BlackBricks. All rights reserved.
//

import UIKit
import CoreBluetooth

class BricksCollectionViewCell: UICollectionViewCell {
    
    var brick: Brick?
    
    @IBOutlet weak var deviceName: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var deviceImage: UIImageView!
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var onOffDeviceButton: UIButton!
    @IBOutlet weak var connectedLabel: UILabel!
    
    
    @IBAction func connectToBrick(_ sender: UIButton) {
        guard let peripheral = brick?.peripheral else { return }
        if peripheral.state == .connecting || peripheral.state == .connected {
            CentralBluetoothManager.default.disconnect(peripheral: peripheral)
        } else {
            CentralBluetoothManager.default.connect(peripheral: peripheral)
            
        }
    }
    
    @IBAction func onOffDevice(_ sender: UIButton) {
        
        guard let brick = self.brick, let peripheralCharacteristic = brick.tx else { return }
        brick.status = brick.status == .on ? .off : .on;
        onOffDeviceButton.setTitle( brick.status == .on ? "ON" : "OFF", for: .normal)
        guard let peripheral = brick.peripheral else { return }
        let onOffCommandData = CentralBluetoothManager.default.OnOff()
        var dataToWrite = Data()
        dataToWrite.append(0xE7)
        dataToWrite.append(0xF1)
        if brick.status == .on {
            dataToWrite.append(0x01)
        } else {
            dataToWrite.append(0x00)
            
        }
        println("Set brick(\(peripheral.name ?? "noname")/\(peripheral.identifier)) state: \(brick.status == .on)")
        CentralBluetoothManager.default.sendCommand(to: peripheral, characteristic: peripheralCharacteristic, data: dataToWrite)
    }
    
    
    func configure(brick: Brick) {
        self.brick = brick
        deviceName.text = brick.deviceName
        guard let brickState = brick.peripheral?.state else {
            return
        }
        switch brickState {
        case .disconnected:
            onOffDeviceButton.isHidden = true
            connectedLabel.isHidden = true
            connectButton.isHidden = false
        case .connected:
            onOffDeviceButton.isHidden = false
            connectedLabel.isHidden = false
            connectButton.isHidden = true
        case .connecting:
            onOffDeviceButton.isHidden = true
            connectedLabel.isHidden = false
            connectedLabel.text = "CONNECTING"
            connectButton.isHidden = true
        default:
            break
        }
    }
}