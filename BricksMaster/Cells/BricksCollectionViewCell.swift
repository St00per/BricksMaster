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
        
        guard let brick = self.brick, let peripheralCharacteristic = CentralBluetoothManager.default.bricksCharacteristic else { return }
        guard let peripheral = brick.peripheral else { return }
        let onOffCommandData = CentralBluetoothManager.default.OnOff()
        peripheral.writeValue(onOffCommandData,
                              for: peripheralCharacteristic,
                              type: CBCharacteristicWriteType.withResponse)
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
