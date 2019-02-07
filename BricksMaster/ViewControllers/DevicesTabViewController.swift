//
//  DevicesTabViewController.swift
//  BricksMaster
//
//  Created by Kirill Shteffen on 15/01/2019.
//  Copyright © 2019 BlackBricks. All rights reserved.
//

import UIKit

class DevicesTabViewController: UIViewController {
    
    @IBOutlet weak var noBricksDevicesView: UIView!
    
    @IBOutlet weak var bricksCount: UILabel!
    @IBOutlet weak var bricksCollectionScanButton: UIButton!
    @IBOutlet weak var bricksCollectionView: UICollectionView!
    
    
    @IBOutlet weak var noFootDevicesView: UIView!
    
    @IBOutlet weak var footswitchCount: UILabel!
    @IBOutlet weak var footswitchesCollectionView: UICollectionView!
    @IBOutlet weak var footswitchesCollectionScanButton: UIButton!
    
    @IBOutlet var footswitchEditView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //DataBaseManager.client.restoreBase()
        //CentralBluetoothManager.default.startScan()
        CentralBluetoothManager.default.devicesTabViewController = self
    }

    override func viewWillAppear(_ animated: Bool) {
        if UserDevicesManager.default.userBricks.count == 0 {
            noBricksDevicesView.isHidden = false
        } else {
            noBricksDevicesView.isHidden = true
        }
        if UserDevicesManager.default.userFootswitches.count == 0 {
            noFootDevicesView.isHidden = false
        } else {
            noFootDevicesView.isHidden = true
        }
        bricksCollectionView.reloadData()
        bricksCount.text = "(\(UserDevicesManager.default.userBricks.count))"
        footswitchesCollectionView.reloadData()
        footswitchCount.text = "(\(UserDevicesManager.default.userFootswitches.count))"
        
    }
    
    @IBAction func bricksScanButtonTouched(_ sender: UIButton) {
        scanForBricks()
    }
    
    @IBAction func footswitchesScanButtonTouched(_ sender: UIButton) {
        scanForFootswitches()
    }
    
    func scanForBricks() {
        CentralBluetoothManager.default.centralManager.scanForPeripherals(withServices: [bricksCBUUID])
    }
    
    func scanForFootswitches() {
        CentralBluetoothManager.default.centralManager.scanForPeripherals(withServices: [footswitchesServiceCBUUID])
    }
    
}
extension DevicesTabViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == bricksCollectionView {
            return UserDevicesManager.default.userBricks.count
        }
        if collectionView == footswitchesCollectionView {
            return UserDevicesManager.default.userFootswitches.count
        }
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == bricksCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrickCell", for: indexPath) as? BricksCollectionViewCell else {
                return UICollectionViewCell()
            }
            let currentBrick = UserDevicesManager.default.userBricks[indexPath.row]
            cell.controller = self
            cell.configure(brick: currentBrick)
//            if currentBrick.imageId == nil {
//                cell.deviceImage.addDashedBorder()
//            }
            cell.dropShadow()
            return cell
        }
        if collectionView == footswitchesCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FootswitchCell", for: indexPath) as? FootswitchesCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            let currentFootswitch = UserDevicesManager.default.userFootswitches[indexPath.row]
            cell.controller = self
            cell.configure(footswitch: currentFootswitch)
            cell.dropShadow()
            return cell
        }
        return UICollectionViewCell()
    }
    
    
}
