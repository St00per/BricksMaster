//
//  PresetSettingViewController.swift
//  BricksMaster
//
//  Created by Kirill Shteffen on 17/01/2019.
//  Copyright © 2019 BlackBricks. All rights reserved.
//

import UIKit

class PresetSettingViewController: UIViewController {

    var currentPresetIndex: Int = 0
    var presetName: String = "Unnamed"
    
    @IBAction func closePresetSetting(_ sender: UIButton) {
        //UserDevicesManager.default.userPresets.remove(at: currentPresetIndex)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var footswitchButton: UIButton!
    
    
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
        
        UserDevicesManager.default.userPresets[currentPresetIndex].name = presetName
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet var footswitchPicker: UIView!
    
    @IBOutlet var bricksPicker: UIView!
    
    
    @IBOutlet weak var presetNameTextField: UITextField!
    
    @IBOutlet weak var presetBricksCollectionView: UICollectionView!
    @IBOutlet weak var footswitchPickerCollectionView: UICollectionView!
    @IBOutlet weak var bricksPickerCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presetNameTextField.text = presetName
        presetNameTextField.delegate = self
        presetNameTextField.returnKeyType = UIReturnKeyType.done
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        guard let presetFootswitchName = UserDevicesManager.default.userPresets[currentPresetIndex].footswitch?.name else { return }
        footswitchButton.setTitle(presetFootswitchName, for: .normal)
        presetBricksCollectionView.reloadData()
    }
    
}
extension PresetSettingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == presetBricksCollectionView {
            return UserDevicesManager.default.userPresets[currentPresetIndex].presetBricks.count
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
        
        if collectionView == presetBricksCollectionView {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PresetSettingsBrickCell", for: indexPath) as? PresetSettingBricksCollectionViewCell else {
            return UICollectionViewCell()
        }
            cell.viewController = self
            cell.presetIndex = currentPresetIndex
            let brickState = UserDevicesManager.default.userPresets[currentPresetIndex].presetBricks[indexPath.row]
            if let brick = UserDevicesManager.default.brick(id: brickState.0) {
                cell.configure(brick: brick, index: indexPath.row)
            }
            return cell
        }
        
        if collectionView == footswitchPickerCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FootswitchPickerCollectionViewCell", for: indexPath) as? FootswitchPickerCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(footswitch: UserDevicesManager.default.userFootswitches[indexPath.row])
            return cell
        }
        
        if collectionView == bricksPickerCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BricksPickerCollectionViewCell", for: indexPath) as? BricksPickerCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(brick: UserDevicesManager.default.userBricks[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == presetBricksCollectionView {}
        
        if collectionView == footswitchPickerCollectionView {
            UserDevicesManager.default.userPresets[currentPresetIndex].footswitch = UserDevicesManager.default.userFootswitches[indexPath.row]
            footswitchPicker.removeFromSuperview()
            guard let presetFootswitchName = UserDevicesManager.default.userPresets[currentPresetIndex].footswitch?.name else { return }
            footswitchButton.setTitle(presetFootswitchName, for: .normal)
        }
        
        if collectionView == bricksPickerCollectionView {
            let appendedBrick = UserDevicesManager.default.userBricks[indexPath.row]
            var canBeAdded = true
            for brickState in UserDevicesManager.default.userPresets[currentPresetIndex].presetBricks {
                if brickState.0 == appendedBrick.id {
                    canBeAdded = false
                    break
                }
            }
            if canBeAdded {
                if let uuid = appendedBrick.id {
                    UserDevicesManager.default.userPresets[currentPresetIndex].presetBricks.append((uuid, appendedBrick.status == .on))
                }
            }
            bricksPicker.removeFromSuperview()
            presetBricksCollectionView.reloadData()
        }
    }
}
extension PresetSettingViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        presetName = textField.text ?? "Unnamed"
        presetNameTextField.resignFirstResponder()
        return true
    }
    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        presetName = textField.text ?? "Unnamed"
//    }
    
}
