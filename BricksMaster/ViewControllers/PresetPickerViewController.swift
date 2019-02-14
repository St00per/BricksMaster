//
//  PresetPickerViewController.swift
//  BricksMaster
//
//  Created by Kirill Shteffen on 17/01/2019.
//  Copyright © 2019 BlackBricks. All rights reserved.
//

import UIKit

class PresetPickerViewController: UIViewController {
    
    var editedFootswitch: Footswitch?
    var editedBank: Bank?
    var footswitchButtonNumber = 0
    
    var completion: (()->Void)?
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var shadow: UIView!
    @IBOutlet weak var mainView: UIView!

    
    @IBAction func closePresetPicker(_ sender: UIButton) {
        close()
    }
    
    func close() {
        completion?()
        UIView.animate(withDuration: 0.4, animations: {
            self.shadow.alpha = 0.0
            var frame = self.mainView.frame
            frame.origin.y = self.view.bounds.height
            self.mainView.frame = frame
        }, completion: { selected in
            self.dismiss(animated: false, completion: nil)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shadow.alpha = 0.0
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.4, animations: {
            self.shadow.alpha = 0.45
            var frame = self.mainView.frame
            frame.origin.y = self.view.bounds.height - 500
            self.mainView.frame = frame
        }, completion: nil)
    }
    
    func setPresetToFootswitchButton(preset: Preset) {
 
        //let footswitchArray = UserDevicesManager.default.userFootswitches
        guard let editedFootswitch = self.editedFootswitch, let editedBank = self.editedBank else { return }
        //guard let footswitchIndex = footswitchArray.firstIndex(of: currentFootswitch) else { return }
        
        //let bank = UserDevicesManager.default.userFootswitches[footswitchIndex].banks.first{$0.id == currentBank.id}
        editedBank.presets[footswitchButtonNumber] = preset
        //guard let updatedBank = bank else { return }
        //updatedBank.save()
        editedBank.save()
        editedFootswitch.save()
        close()
    }

    
}
extension PresetPickerViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (editedFootswitch?.presets.count ?? 0) + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PresetPickerCell", for: indexPath) as? PresetPickerCollectionViewCell else {
            return UICollectionViewCell()
        }
        if indexPath.row == 0 {
            cell.presetName.text = "No preset"
            cell.bricksIndicatorsView.isHidden = true
            let bankPresets = editedBank?.presets
            if editedBank?.presets[footswitchButtonNumber].id == nil {
                cell.selectionMarker.image = UIImage(named: "round select")
            } else {
                cell.selectionMarker.image = UIImage(named: "round unselect")
            }
            return cell
        } else {
        cell.bank = self.editedBank
        cell.footswitchButtonIndex = footswitchButtonNumber
        if let currentPreset = editedFootswitch?.presets[indexPath.row - 1] {
            cell.configure(preset: currentPreset)
        }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            setPresetToFootswitchButton(preset: Preset())
        } else {
        guard let selectedPreset = editedFootswitch?.presets[indexPath.row - 1 ] else { return }
        setPresetToFootswitchButton(preset: selectedPreset)
        }
    }
}
