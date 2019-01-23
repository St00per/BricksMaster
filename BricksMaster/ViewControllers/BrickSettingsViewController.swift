//
//  BrickSettingsViewController.swift
//  BricksMaster
//
//  Created by Kirill Shteffen on 23/01/2019.
//  Copyright © 2019 BlackBricks. All rights reserved.
//

import UIKit

class BrickSettingsViewController: UIViewController {

    var currentBrick: Brick?
    var assignedFootswitch: Footswitch?
    
    @IBOutlet weak var brickName: UITextField!
    
    @IBOutlet var footswitchPicker: UIView!
    
    @IBOutlet weak var brickSettingsView: UIView!
    @IBOutlet weak var assignedFootswitchName: UIButton!
    @IBOutlet weak var footswitchPickerCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assignedFootswitch = currentBrick?.assignedFootswitch
        brickName.text = currentBrick?.deviceName
        if assignedFootswitch != nil {
            assignedFootswitchName.setTitle(assignedFootswitch?.name, for: .normal)
        }
    }
    
    @IBAction func showFootswitchPicker(_ sender: UIButton) {
        brickSettingsView.isUserInteractionEnabled = false
        brickSettingsView.alpha = 0.4
        self.view.addSubview(footswitchPicker)
        footswitchPicker.center = self.view.center
        
    }
    
    @IBAction func closeFootswitchPicker(_ sender: UIButton) {
        footswitchPicker.removeFromSuperview()
        brickSettingsView.alpha = 1
        brickSettingsView.isUserInteractionEnabled = true
    }
    
    
    @IBAction func closeBrickSettings(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveBrickSettings(_ sender: UIButton) {
        guard let currentBrick = self.currentBrick, let assignedFootswitch = self.assignedFootswitch else { return }
        assignedFootswitch.bricks.append(currentBrick)
        currentBrick.assignedFootswitch = self.assignedFootswitch
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
extension BrickSettingsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == footswitchPickerCollectionView {
            return UserDevicesManager.default.userFootswitches.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == footswitchPickerCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FootswitchPickerCollectionViewCell", for: indexPath) as? FootswitchPickerCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(footswitch: UserDevicesManager.default.userFootswitches[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == footswitchPickerCollectionView {
            assignedFootswitch = UserDevicesManager.default.userFootswitches[indexPath.row]
            footswitchPicker.removeFromSuperview()
            brickSettingsView.alpha = 1
            brickSettingsView.isUserInteractionEnabled = true
            assignedFootswitchName.setTitle(assignedFootswitch?.name, for: .normal)
            
        }
    }
    
}
