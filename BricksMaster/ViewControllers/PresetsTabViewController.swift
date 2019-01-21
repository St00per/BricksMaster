//
//  PresetsTabViewController.swift
//  BricksMaster
//
//  Created by Kirill Shteffen on 17/01/2019.
//  Copyright © 2019 BlackBricks. All rights reserved.
//

import UIKit

class PresetsTabViewController: UIViewController {

    enum CollState {
        case presets
        case banks
    }
    
    var collectionViewState: CollState = .presets
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(true)
        collectionView.reloadData()
    }
    
    @IBAction func showPresetSetting(_ sender: UIButton) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let desVC = mainStoryboard.instantiateViewController(withIdentifier: "PresetSettingViewController") as? PresetSettingViewController else {
            return
        }
        let newPreset = Preset()
        UserDevicesManager.default.userPresets.append(newPreset)
        desVC.currentPresetIndex = UserDevicesManager.default.userPresets.count - 1
        show(desVC, sender: nil)
    }
    
    @IBAction func showPresets(_ sender: UIButton) {
        collectionViewState = .presets
        collectionView.reloadData()
    }
    
    @IBAction func showBanks(_ sender: UIButton) {
        collectionViewState = .banks
        collectionView.reloadData()
    }
    
    
}
extension PresetsTabViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionViewState == .presets {
            return UserDevicesManager.default.userPresets.count
        }
        
        if collectionViewState == .banks {
            return UserDevicesManager.default.userBanks.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionViewState == .presets {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PresetsTabCell", for: indexPath) as? PresetsTabCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(preset: UserDevicesManager.default.userPresets[indexPath.row])
            return cell
        }
        
        if collectionViewState == .banks {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PresetsTabCell", for: indexPath) as? PresetsTabCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(bank: UserDevicesManager.default.userBanks[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionViewState == .presets {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let desVC = mainStoryboard.instantiateViewController(withIdentifier: "PresetSettingViewController") as? PresetSettingViewController else {
            return
        }
        desVC.presetName = UserDevicesManager.default.userPresets[indexPath.row].name
        desVC.currentPresetIndex = indexPath.row
        show(desVC, sender: nil)
        }
    
    
    if collectionViewState == .banks {
    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    guard let desVC = mainStoryboard.instantiateViewController(withIdentifier: "FootswitchEditViewController") as? FootswitchEditViewController else {
    return
    }
    desVC.currentFootswitch = UserDevicesManager.default.userFootswitches.first
    desVC.currentBank = UserDevicesManager.default.userBanks.first
    show(desVC, sender: nil)
            }
        }
    
}
