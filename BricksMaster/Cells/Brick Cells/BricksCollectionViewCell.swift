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
    var controller: DevicesTabViewController?
    
    @IBOutlet weak var deviceName: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var deviceImage: UIImageView!
    @IBOutlet weak var deviceColor: UIView!
    
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var onOffDeviceButton: UIButton!
    @IBOutlet weak var connectedLabel: UILabel!
    @IBOutlet weak var connectedLabelView: UIView!
    
    
    
    @IBAction func connectToBrick(_ sender: UIButton) {
        guard let brick = brick, let peripheral = brick.peripheral else { return }
        if peripheral.state == .connecting || peripheral.state == .connected {
            CentralBluetoothManager.default.disconnect(peripheral: peripheral)
        } else {
            UserDevicesManager.default.connect(brick: brick)
        }
    }
    
    @IBAction func showBrickEdit(_ sender: UIButton) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "BrickSettings", bundle: nil)
        guard let desVC = mainStoryboard.instantiateViewController(withIdentifier: "BrickSettingsViewController") as? BrickSettingsViewController else {
            return
        }
        
        desVC.currentBrick = self.brick
        controller?.show(desVC, sender: nil)
    }
    
    @IBAction func onOffDevice(_ sender: UIButton) {
        
        guard let brick = self.brick, let peripheralCharacteristic = brick.tx else { return }
        brick.status = brick.status == .on ? .off : .on;
        onOffDeviceButton.setTitle( brick.status == .on ? "ON" : "OFF", for: .normal)
        onOffDeviceButton.backgroundColor = brick.status == .on ? UIColor(hexString: "94C15B") : UIColor(hexString: "DE6969")
        guard let peripheral = brick.peripheral else { return }
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
        deviceImage.image = UIImage(named: brick.imageId ?? "")
        deviceColor.backgroundColor = brick.color
        connectedLabelView.layer.cornerRadius = 4
        connectedLabelView.isHidden = true
        onOffDeviceButton.isHidden = true
        guard let brickState = brick.peripheral?.state else {
            return
        }
        switch brickState {
            
        case .disconnected:
            onOffDeviceButton.isHidden = true
            connectedLabelView.isHidden = true
            connectButton.isHidden = false
        case .connected:
            onOffDeviceButton.isHidden = false
            connectedLabelView.isHidden = false
            connectedLabel.text = "CONNECTED"
            connectButton.isHidden = true
        case .connecting:
            onOffDeviceButton.isHidden = true
            connectedLabelView.isHidden = false
            connectedLabel.text = "CONNECTING"
            connectButton.isHidden = true
        default:
            break
        }
    }
}
