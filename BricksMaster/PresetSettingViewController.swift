//
//  PresetSettingViewController.swift
//  BricksMaster
//
//  Created by Kirill Shteffen on 17/01/2019.
//  Copyright © 2019 BlackBricks. All rights reserved.
//

import UIKit

class PresetSettingViewController: UIViewController {

    @IBAction func closePresetSetting(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func showFootswitchPicker(_ sender: UIButton) {
        self.view.addSubview(footswitchPicker)
        footswitchPicker.center = self.view.center
    }
    @IBAction func closeFootswitchPicker(_ sender: UIButton) {
        footswitchPicker.removeFromSuperview()
    }
    
    @IBAction func showBrickPicker(_ sender: UIButton) {
        self.view.addSubview(bricksPicker)
        bricksPicker.center = self.view.center
    }
    
    @IBAction func closeBrickPicker(_ sender: UIButton) {
        bricksPicker.removeFromSuperview()
    }
    
    @IBAction func savePreset(_ sender: UIButton) {
        let newPreset = Preset(id: 5, name: "Five")
        UserDevicesManager.default.userPresets.append(newPreset)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet var footswitchPicker: UIView!
    
    @IBOutlet var bricksPicker: UIView!
    
    
    @IBOutlet weak var presetNameTextField: UITextField!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var footswitchPickerCollectionView: UICollectionView!
    @IBOutlet weak var bricksPickerCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
extension PresetSettingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionView {
            return UserDevicesManager.default.userPresets[0].bricksState.count
        }
        if collectionView == footswitchPickerCollectionView {
            return UserDevicesManager.default.userFootswitches.count
        }
        if collectionView == bricksPickerCollectionView {
            return UserDevicesManager.default.userBricks.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == collectionView {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PresetSettingsBrickCell", for: indexPath) as? PresetSettingBricksCollectionViewCell else {
            return UICollectionViewCell()
        }
            //cell.configure(brick: UserDevicesManager.default.userPresets[0].bricksState[indexPath.row])
            return cell
        }
        
        if collectionView == footswitchPickerCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FootswitchPickerCollectionViewCell", for: indexPath) as? FootswitchPickerCollectionViewCell else {
                return UICollectionViewCell()
            }
            //cell.configure(brick: UserDevicesManager.default.userFootswitches[indexPath.row])
            return cell
        }
        
        if collectionView == bricksPickerCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BricksPickerCollectionViewCell", for: indexPath) as? BricksPickerCollectionViewCell else {
                return UICollectionViewCell()
            }
            //cell.configure(brick: UserDevicesManager.default.userBricks[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
}
