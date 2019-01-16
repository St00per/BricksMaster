//
//  DevicesTabViewController.swift
//  BricksMaster
//
//  Created by Kirill Shteffen on 15/01/2019.
//  Copyright © 2019 BlackBricks. All rights reserved.
//

import UIKit

class DevicesTabViewController: UIViewController {
    
    
    @IBOutlet weak var bricksCollectionScanButton: UIButton!
    @IBOutlet weak var bricksCollectionView: UICollectionView!
    
    @IBOutlet weak var footswitchesCollectionView: UICollectionView!
    @IBOutlet weak var footswitchesCollectionScanButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    func scanForBricks() {
        CentralBluetoothManager.default.centralManager.scanForPeripherals(withServices: [bricksCBUUID])
    }
    
    func scanForFootswitches() {
        CentralBluetoothManager.default.centralManager.scanForPeripherals(withServices: [footswitchesCBUUID])
    }
    
}
extension DevicesTabViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == bricksCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrickCell", for: indexPath) as? BricksCollectionViewCell else {
                return UICollectionViewCell()
            }
            return cell
        }
        if collectionView == footswitchesCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FootswitchCell", for: indexPath) as? FootswitchesCollectionViewCell else {
                return UICollectionViewCell()
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    
}
