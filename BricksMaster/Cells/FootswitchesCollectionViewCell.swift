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
    @IBOutlet weak var footswitchBricksCollectionView: UICollectionView!
    
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    override func awakeFromNib() {
        footswitchBricksCollectionView.isHidden = false//test
        footswitchBricksCollectionView.delegate = self
        footswitchBricksCollectionView.dataSource = self
    }
    
    @IBAction func showFootswitchEdit(_ sender: UIButton) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "FootswitchEdit", bundle: nil)
        guard let desVC = mainStoryboard.instantiateViewController(withIdentifier: "FootswitchEditViewController") as? FootswitchEditViewController else {
            return
        }
     
        desVC.currentFootswitch = self.footswitch
        desVC.currentBank = self.footswitch?.selectedBank
        controller?.show(desVC, sender: nil)
    }
    
    func footswitchConnectionStateChanged(connected: Bool, peripheralId: UUID) {
        guard let footswitchState = footswitch?.peripheral?.state else { return }
        switch footswitchState {
        case .disconnected:
            editButton.isHidden = true
            connectButton.isHidden = false
            footswitchBricksCollectionView.isHidden = true
        case .connected:
            editButton.isHidden = false
            connectButton.isHidden = true
            footswitchBricksCollectionView.isHidden = false
        case .connecting:
            editButton.isHidden = true
            connectButton.isHidden = true
            footswitchBricksCollectionView.isHidden = true
        default:
            break
        }
    }
    
    func configure(footswitch: Footswitch) {
        deviceName.text = footswitch.name
        //deviceName.text = footswitch.peripheral?.name - commented for testing
        self.footswitch = footswitch
        self.footswitch?.observers.removeAll()
        self.footswitch?.subscribe(observer: self)
        footswitchBricksCollectionView.reloadData()//test
        guard let footswitchState = footswitch.peripheral?.state else { return }
        switch footswitchState {
        case .disconnected:
            editButton.isHidden = true
            connectButton.isHidden = false
        case .connected:
            editButton.isHidden = false
            connectButton.isHidden = true
            footswitchBricksCollectionView.reloadData()
        case .connecting:
            editButton.isHidden = true
            connectButton.isHidden = true
        default:
            break
        }
        
    }
    
    @IBAction func connect(_ sender: Any?) {
        guard let footswitch = footswitch, let peripheral = footswitch.peripheral else {
           return
        }
       UserDevicesManager.default.connect(footswitch: footswitch)
    }
}
extension FootswitchesCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let footswitch = self.footswitch else { return 0 }
        return footswitch.bricks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FootswitchBricksCollectionViewCell", for: indexPath) as? FootswitchBricksCollectionViewCell, let brick = footswitch?.bricks[indexPath.row] else {
            return UICollectionViewCell()
        }
        
        
        cell.configure(brick: brick)
        //cell.width.constant = indexPath.item == 2 || indexPath.item == 3 ? 49 : 40
        //cell.height.constant = 60
        
        return cell
    }
    
    
}
