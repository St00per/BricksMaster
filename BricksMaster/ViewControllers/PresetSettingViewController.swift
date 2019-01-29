//
//  PresetSettingViewController.swift
//  BricksMaster
//
//  Created by Kirill Shteffen on 17/01/2019.
//  Copyright © 2019 BlackBricks. All rights reserved.
//

import UIKit

class PresetSettingViewController: UIViewController {
    
    //    var currentFootswitch: Footswitch?
    //    var currentPresetIndex: Int = 0
    //var presetName: String = "Unnamed"
    
    var preset: Preset?
    var viewShadow: UIView?
    
    @IBOutlet weak var presetNameHeader: UILabel!
    
    @IBOutlet weak var presetNameTextFieldView: UIView!
    
    @IBOutlet weak var bricksHeaderLabel: UILabel!
    
    @IBOutlet weak var savePresetButton: UIButton!
    
    @IBAction func closePresetSetting(_ sender: UIButton) {
        //UserDevicesManager.default.userPresets.remove(at: currentPresetIndex)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var footswitchButton: UIButton!
    
    @IBOutlet weak var presetSettingsView: UIView!
    
    @IBAction func showFootswitchPicker(_ sender: UIButton) {
        if let viewShadow = viewShadow {
            self.view.addSubview(viewShadow)
        }
        presetSettingsView.isUserInteractionEnabled = false
        self.view.addSubview(footswitchPicker)
        footswitchPicker.frame = CGRect(x: 16, y: self.view.bounds.size.height, width: self.view.bounds.size.width - 32, height: 320)
        UIView.animate(withDuration: 0.3, animations: {
            self.viewShadow?.alpha = 0.45
            self.footswitchPicker.frame = CGRect(x: 0, y: self.view.bounds.size.height - 320, width: self.view.bounds.size.width, height: 320)
        }) { (isFinished) in
        }

    }
    @IBAction func closeFootswitchPicker(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3, animations: {
            self.footswitchPicker.frame = CGRect(x: 0, y: self.view.bounds.size.height, width: self.view.bounds.size.width, height: 320)
            self.viewShadow?.alpha = 0.0
        }) { (isFinished) in
            self.presetSettingsView.isUserInteractionEnabled = true
            self.footswitchPicker.removeFromSuperview()
            self.viewShadow?.removeFromSuperview()
        }
       
    }
    
    func showBrickPicker() {
        self.view.addSubview(bricksPicker)
        bricksPicker.center = self.view.center
    }
    
    @IBAction func closeBrickPicker(_ sender: UIButton) {
        bricksPicker.removeFromSuperview()
    }
    
    @IBAction func savePreset(_ sender: UIButton) {
        guard let footswitch = self.preset?.footswitch, let preset = self.preset else { return }
        if !footswitch.presets.contains(preset) {
            preset.footswitch?.presets.append(preset)
            preset.save()
            preset.footswitch?.save()
            self.dismiss(animated: true, completion: nil)
        } else {
            preset.save()
            preset.footswitch?.save()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBOutlet var footswitchPicker: UIView!
    
    @IBOutlet var bricksPicker: UIView!
    
    
    @IBOutlet weak var presetNameTextField: UITextField!
    
    @IBOutlet weak var presetBricksCollectionView: UICollectionView!
    @IBOutlet weak var footswitchPickerCollectionView: UICollectionView!
    @IBOutlet weak var bricksPickerCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let preset = preset {
            
        } else {
            preset = Preset(id: UUID().uuidString, name: "")
        }
        self.presetBricksCollectionView.register(UINib(nibName: "AddBrickPresetCell", bundle: nil), forCellWithReuseIdentifier: "AddBrickPresetCell")
        outletsVisibilityCheck()
        presetNameTextField.text = preset?.name
        presetNameTextField.delegate = self
        presetNameTextField.returnKeyType = UIReturnKeyType.done
        
        viewShadow = UIView(frame: UIScreen.main.bounds)
        viewShadow?.backgroundColor = UIColor.black
        viewShadow?.alpha = 0.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        guard let presetFootswitchName = preset?.footswitch?.name else { return }
        footswitchButton.setTitle(presetFootswitchName, for: .normal)
        presetBricksCollectionView.reloadData()
    }
    
    func outletsVisibilityCheck() {
        if self.preset?.footswitch == nil {
            presetNameHeader.isHidden = true
            presetNameTextFieldView.isHidden = true
            bricksHeaderLabel.isHidden = true
            savePresetButton.isHidden = true
            presetBricksCollectionView.isHidden = true
        } else {
            presetNameHeader.isHidden = false
            presetNameTextFieldView.isHidden = false
            bricksHeaderLabel.isHidden = false
            savePresetButton.isHidden = false
            presetBricksCollectionView.isHidden = false
        }
    }
    
}
extension PresetSettingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == presetBricksCollectionView {
            guard let count = preset?.footswitch?.bricks.count else {
                return 1
            }
            return count + 1
        }
        if collectionView == footswitchPickerCollectionView {
            let footswitches = UserDevicesManager.default.userFootswitches//.filter{ !$0.new }
            return footswitches.count
        }
        if collectionView == bricksPickerCollectionView {
            return preset?.footswitch?.bricks.count ?? 0
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == presetBricksCollectionView {
            guard let count = preset?.footswitch?.bricks.count else {
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddBrickPresetCell", for: indexPath) as? AddBrickPresetCell else {
                    return UICollectionViewCell()
                }
                cell.configure()
                return cell
            }
            if count > 0, indexPath.row < count {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PresetSettingsBrickCell", for: indexPath) as? PresetSettingBricksCollectionViewCell else {
                    return UICollectionViewCell()
                }
                cell.viewController = self
                cell.preset = preset
                guard let brickState = preset?.presetBricks[indexPath.row] else {
                    return UICollectionViewCell()
                }
                if let brick = UserDevicesManager.default.brick(id: brickState.0) {
                    cell.configure(brick: brick, index: indexPath.row)
                }
                return cell
            } else {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddBrickPresetCell", for: indexPath) as? AddBrickPresetCell else {
                    return UICollectionViewCell()
                }
                cell.configure()
                return cell
            }
        }
        
        if collectionView == footswitchPickerCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FootswitchPickerCollectionViewCell", for: indexPath) as? FootswitchPickerCollectionViewCell else {
                return UICollectionViewCell()
            }
            let footswitches = UserDevicesManager.default.userFootswitches//.filter{ !$0.new }
            cell.configure(footswitch: footswitches[indexPath.row])
            return cell
        }
        
        if collectionView == bricksPickerCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BricksPickerCollectionViewCell", for: indexPath) as? BricksPickerCollectionViewCell, let bricks =  preset?.footswitch?.bricks else {
                return UICollectionViewCell()
            }
            cell.configure(brick: bricks[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == presetBricksCollectionView {
            guard let count = preset?.presetBricks.count else { return }
            if indexPath.row > count - 1  {
                showBrickPicker()
            }
        }
        
        if collectionView == footswitchPickerCollectionView {
            preset?.footswitch = UserDevicesManager.default.userFootswitches[indexPath.row]
            UIView.animate(withDuration: 0.3, animations: {
                self.footswitchPicker.frame = CGRect(x: 0, y: self.view.bounds.size.height, width: self.view.bounds.size.width, height: 320)
                self.viewShadow?.alpha = 0.0
            }) { (isFinished) in
                self.presetSettingsView.isUserInteractionEnabled = true
                self.footswitchPicker.removeFromSuperview()
                self.viewShadow?.removeFromSuperview()
            }
            guard let presetFootswitchName = preset?.footswitch?.name else { return }
            footswitchButton.setTitle(presetFootswitchName, for: .normal)
            outletsVisibilityCheck()
        }
        
        if collectionView == bricksPickerCollectionView {
            guard let appendedBrick = preset?.footswitch?.bricks[indexPath.row], let bricks =  preset?.presetBricks else { return }
            var canBeAdded = true
            for brickState in bricks {
                if brickState.0 == appendedBrick.id {
                    canBeAdded = false
                    break
                }
            }
            if canBeAdded {
                if let uuid = appendedBrick.id {
                    preset?.presetBricks.append((uuid, appendedBrick.status == .on))
                }
            }
            bricksPicker.removeFromSuperview()
            presetBricksCollectionView.reloadData()
        }
    }
}
extension PresetSettingViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        preset?.name = textField.text ?? "Unnamed"
        presetNameTextField.resignFirstResponder()
        return true
    }
}
