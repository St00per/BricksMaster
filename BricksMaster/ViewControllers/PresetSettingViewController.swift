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
    
    var currentPreset: Preset?
    var viewShadow: UIView?
    var appendedBricks: [(String, Bool)] = []
    var unappendedBricks: [Brick] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let preset = currentPreset {
            
        } else {
            currentPreset = Preset(id: UUID().uuidString, name: "")
        }
        
        fillAppendedBricksArray()
        self.presetBricksCollectionView.register(UINib(nibName: "AddBrickPresetCell", bundle: nil), forCellWithReuseIdentifier: "AddBrickPresetCell")
        outletsVisibilityCheck()
        presetNameTextField.text = currentPreset?.name
        presetNameTextField.delegate = self
        presetNameTextField.returnKeyType = UIReturnKeyType.done
        
        viewShadow = UIView(frame: UIScreen.main.bounds)
        viewShadow?.backgroundColor = UIColor.black
        viewShadow?.alpha = 0.0
        
        savePresetButton.dropShadow()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        guard let presetFootswitchName = currentPreset?.footswitch?.name else { return }
        footswitchButton.setTitle(presetFootswitchName, for: .normal)
        presetBricksCollectionView.reloadData()
    }
    
    @IBOutlet weak var presetNameHeader: UILabel!
    
    @IBOutlet weak var presetNameTextFieldView: UIView!
    
    @IBOutlet weak var bricksHeaderLabel: UILabel!
    
    @IBOutlet weak var savePresetButton: UIButton!
    
    @IBOutlet weak var footswitchButton: UIButton!
    
    @IBOutlet weak var presetSettingsView: UIView!
    
    @IBOutlet var footswitchPicker: UIView!
    
    @IBOutlet var bricksPicker: UIView!
    
    @IBOutlet weak var presetNameTextField: UITextField!
    
    @IBOutlet weak var presetBricksCollectionView: UICollectionView!
    
    @IBOutlet weak var footswitchPickerCollectionView: UICollectionView!
    
    @IBOutlet weak var bricksPickerCollectionView: UICollectionView!
    
    
    
    
    @IBAction func closePresetSetting(_ sender: UIButton) {
        //UserDevicesManager.default.userPresets.remove(at: currentPresetIndex)
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func showFootswitchPicker(_ sender: UIButton) {
        if let viewShadow = viewShadow {
            self.view.addSubview(viewShadow)
        }
        presetSettingsView.isUserInteractionEnabled = false
        self.view.addSubview(footswitchPicker)
        footswitchPicker.frame = CGRect(x: 16,
                                        y: self.view.bounds.size.height,
                                        width: self.view.bounds.size.width - 32,
                                        height: 320)
        UIView.animate(withDuration: 0.3, animations: {
            self.viewShadow?.alpha = 0.45
            self.footswitchPicker.frame = CGRect(x: 0,
                                                 y: self.view.bounds.size.height - 300,
                                                 width: self.view.bounds.size.width,
                                                 height: 320)
        }) { (isFinished) in
        }
        
    }
    
    @IBAction func closeFootswitchPicker(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3, animations: {
            self.footswitchPicker.frame = CGRect(x: 0,
                                                 y: self.view.bounds.size.height,
                                                 width: self.view.bounds.size.width,
                                                 height: 320)
            self.viewShadow?.alpha = 0.0
        }) { (isFinished) in
            self.presetSettingsView.isUserInteractionEnabled = true
            self.footswitchPicker.removeFromSuperview()
            self.viewShadow?.removeFromSuperview()
        }
        
    }
    
    func fillAppendedBricksArray() {
        guard let presetBricksArray = currentPreset?.presetBricks else { return }
        self.appendedBricks = presetBricksArray
    }
    
    func showBrickPicker() {
        
        //MARK: fill bricks arrays
        guard let footswitchBricksArray = currentPreset?.footswitch?.bricks else { return }
        fillAppendedBricksArray()
        unappendedBricks = []
        for footBrick in footswitchBricksArray {
            var checkedBrick = ("",false)
            checkedBrick.0 = footBrick.id ?? ""
            if footBrick.status == .off {
                checkedBrick.1 = false
            } else {
                checkedBrick.1 = true
            }
            if !self.appendedBricks.contains{ $0 == checkedBrick } {
                unappendedBricks.append(footBrick)
            }
        }
        bricksPickerCollectionView.reloadData()
        
        if let viewShadow = viewShadow {
            self.view.addSubview(viewShadow)
        }
        presetSettingsView.isUserInteractionEnabled = false
        self.view.addSubview(bricksPicker)
        bricksPicker.frame = CGRect(x: 16,
                                    y: self.view.bounds.size.height,
                                    width: self.view.bounds.size.width - 50,
                                    height: 500)
        UIView.animate(withDuration: 0.3, animations: {
            self.viewShadow?.alpha = 0.45
            self.bricksPicker.frame = CGRect(x: 0,
                                             y: self.view.bounds.size.height - 500,
                                             width: self.view.bounds.size.width,
                                             height: 500)
        }) { (isFinished) in
        }
    }
    
    
    
    @IBAction func closeBrickPicker(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3, animations: {
            self.bricksPicker.frame = CGRect(x: 0,
                                             y: self.view.bounds.size.height,
                                             width: self.view.bounds.size.width,
                                             height: 500)
            self.viewShadow?.alpha = 0.0
        }) { (isFinished) in
            self.presetSettingsView.isUserInteractionEnabled = true
            self.bricksPicker.removeFromSuperview()
            self.viewShadow?.removeFromSuperview()
        }
    }
    
    @IBAction func addSelectedBricksToPreset(_ sender: UIButton) {
        guard var presetBricksArray = currentPreset?.presetBricks else { return }
        
        for brick in self.appendedBricks {
            if !presetBricksArray.contains{ $0 == brick }
            {
                presetBricksArray.append(brick)
            }
        }
        currentPreset?.presetBricks = presetBricksArray
        UIView.animate(withDuration: 0.3, animations: {
            self.bricksPicker.frame = CGRect(x: 0,
                                             y: self.view.bounds.size.height,
                                             width: self.view.bounds.size.width,
                                             height: 500)
            self.viewShadow?.alpha = 0.0
        }) { (isFinished) in
            self.presetSettingsView.isUserInteractionEnabled = true
            self.bricksPicker.removeFromSuperview()
            self.viewShadow?.removeFromSuperview()
        }
        presetBricksCollectionView.reloadData()
    }
    
    
    @IBAction func savePreset(_ sender: UIButton) {
        guard let footswitch = self.currentPreset?.footswitch, let preset = self.currentPreset else { return }
        if !footswitch.presets.contains(preset) {
            preset.footswitch?.presets.append(preset)
            preset.presetObject?.id = preset.id
            preset.presetObject?.footswitch = footswitch.id
            preset.presetObject?.name = preset.name
            preset.save()
            preset.footswitch?.save()
            self.dismiss(animated: true, completion: nil)
        } else {
            preset.save()
            preset.footswitch?.save()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    
    func outletsVisibilityCheck() {
        if self.currentPreset?.footswitch == nil {
            presetNameHeader.isHidden = true
            presetNameTextFieldView.isHidden = true
            presetNameTextField.isHidden = true
            bricksHeaderLabel.isHidden = true
            savePresetButton.isHidden = true
            presetBricksCollectionView.isHidden = true
        } else {
            presetNameTextField.isHidden = false
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
        guard let preset = self.currentPreset else {
            return 1
        }
        
        let presetBricksCount = preset.presetBricks.count
        
        if collectionView == presetBricksCollectionView {
            
            if presetBricksCount == 0, preset.footswitch?.bricks.count == 0 {
                return 0
            }
            
            if presetBricksCount == preset.footswitch?.bricks.count {
                return presetBricksCount
            } else {
                return presetBricksCount + 1
            }
        }
        
        if collectionView == footswitchPickerCollectionView {
            let footswitches = UserDevicesManager.default.userFootswitches.filter{ !$0.new }
            return footswitches.count
        }
        
        if collectionView == bricksPickerCollectionView {
            return unappendedBricks.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let preset = self.currentPreset else {
            return UICollectionViewCell()
        }
        
        let presetBricksCount = preset.presetBricks.count
        
        if collectionView == presetBricksCollectionView {
            guard presetBricksCount > 0 else {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddBrickPresetCell", for: indexPath) as? AddBrickPresetCell else {
                    return UICollectionViewCell()
                }
                cell.configure()
                return cell
            }
            
            if indexPath.row < presetBricksCount {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PresetSettingsBrickCell", for: indexPath) as? PresetSettingBricksCollectionViewCell, let currentPreset = self.currentPreset else {
                    return UICollectionViewCell()
                }
                cell.viewController = self
                cell.preset = currentPreset
                let currentBrick = UserDevicesManager.default.userBricks.first{$0.id == currentPreset.presetBricks[indexPath.row].0}
                guard let brick = currentBrick else {
                    return UICollectionViewCell()
                }
                cell.configure(brick: brick, index: indexPath.row)
                cell.dropShadow()
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
            let footswitches = UserDevicesManager.default.userFootswitches.filter{ !$0.new }
            cell.configure(footswitch: footswitches[indexPath.row])
            return cell
        }
        
        if collectionView == bricksPickerCollectionView {
            guard let currentPreset = self.currentPreset, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BricksPickerCollectionViewCell", for: indexPath) as? BricksPickerCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(brick: unappendedBricks[indexPath.row], currentPreset: currentPreset, appendedBricks: self.appendedBricks)
            cell.dropShadow()
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == presetBricksCollectionView {
            guard let count = currentPreset?.presetBricks.count else { return }
            if indexPath.row > count - 1  {
                showBrickPicker()
            }
        }
        
        if collectionView == footswitchPickerCollectionView {
            currentPreset?.footswitch = UserDevicesManager.default.userFootswitches[indexPath.row]
            UIView.animate(withDuration: 0.3, animations: {
                self.footswitchPicker.frame = CGRect(x: 0,
                                                     y: self.view.bounds.size.height,
                                                     width: self.view.bounds.size.width,
                                                     height: 320)
                self.viewShadow?.alpha = 0.0
            }) { (isFinished) in
                self.presetSettingsView.isUserInteractionEnabled = true
                self.footswitchPicker.removeFromSuperview()
                self.viewShadow?.removeFromSuperview()
            }
            guard let presetFootswitchName = currentPreset?.footswitch?.name else { return }
            footswitchButton.setTitle(presetFootswitchName, for: .normal)
            presetBricksCollectionView.reloadData()
            outletsVisibilityCheck()
        }
        
        if collectionView == bricksPickerCollectionView {
            let selectedBrick = unappendedBricks[indexPath.row]
            //            var canBeAdded = true
            //            for brickState in bricks {
            //                if brickState.0 == appendedBrick.id {
            //                    canBeAdded = false
            //                    break
            //                }
            //            }
            //            if canBeAdded {
            //
            ////                if let uuid = appendedBrick.id {
            ////                    preset?.presetBricks.append((uuid, appendedBrick.status == .on))
            ////                }
            //
            
            
            if !appendedBricks.contains{$0.0 == selectedBrick.id} {
                var appendedBrick = ("",false)
                appendedBrick.0 = selectedBrick.id ?? ""
                if selectedBrick.status == .off {
                    appendedBrick.1 = false
                } else {
                    appendedBrick.1 = true
                }
                appendedBricks.append(appendedBrick)
            } else {
                var indexForDelete: Int = 0
                for index in 0..<appendedBricks.count {
                    if appendedBricks[index].0 == selectedBrick.id {
                        indexForDelete = index
                    }
                }
                self.appendedBricks.remove(at: indexForDelete)
            }
            bricksPickerCollectionView.reloadData()
        }
    }
}

extension PresetSettingViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        currentPreset?.name = textField.text ?? "Unnamed"
        presetNameTextField.resignFirstResponder()
        return true
    }
}
