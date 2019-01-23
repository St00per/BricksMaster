//
//  FootswitchesCollectionViewCell.swift
//  BricksMaster
//
//  Created by Kirill Shteffen on 15/01/2019.
//  Copyright © 2019 BlackBricks. All rights reserved.
//

import UIKit

class FootswitchesCollectionViewCell: UICollectionViewCell, ConnectionObserver {
    func brickConnectionStateChanged(connected: Bool, peripheralId: UUID) {
    }
    
    var footswitch: Footswitch?
    var controller: DevicesTabViewController?
    
    @IBOutlet weak var deviceName: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    
    
    @IBAction func connect(_ sender: Any?) {
        guard let footswitch = footswitch, let peripheral = footswitch.peripheral else {
           return
        }
        CentralBluetoothManager.default.connect(peripheral: peripheral)
    }
    
    @IBAction func showFootswitchEdit(_ sender: UIButton) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let desVC = mainStoryboard.instantiateViewController(withIdentifier: "FootswitchEditViewController") as? FootswitchEditViewController else {
            return
        }
     
        desVC.currentFootswitch = self.footswitch
        controller?.show(desVC, sender: nil)
    }
    
    func footswitchConnectionStateChanged(connected: Bool, peripheralId: UUID) {
        guard let footswitchState = footswitch?.peripheral?.state else { return }
        switch footswitchState {
        case .disconnected:
            editButton.isHidden = true
            connectButton.isHidden = false
        case .connected:
            editButton.isHidden = false
            connectButton.isHidden = true
        case .connecting:
            editButton.isHidden = true
            connectButton.isHidden = true
        default:
            break
        }
    }
    
    func configure(footswitch: Footswitch) {
        deviceName.text = footswitch.peripheral?.name
        self.footswitch = footswitch
        self.footswitch?.observers.removeAll()
        self.footswitch?.subscribe(observer: self)
        guard let footswitchState = footswitch.peripheral?.state else { return }
        switch footswitchState {
        case .disconnected:
            editButton.isHidden = true
            connectButton.isHidden = false
        case .connected:
            editButton.isHidden = false
            connectButton.isHidden = true
        case .connecting:
            editButton.isHidden = true
            connectButton.isHidden = true
        default:
            break
        }
        
    }
    
}
