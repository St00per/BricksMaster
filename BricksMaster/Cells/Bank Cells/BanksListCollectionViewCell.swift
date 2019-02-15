//
//  BanksListCollectionViewCell.swift
//  BricksMaster
//
//  Created by Kirill Shteffen on 01/02/2019.
//  Copyright © 2019 BlackBricks. All rights reserved.
//

import UIKit

class BanksListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var bankPresetsCollectionView: UICollectionView!
    @IBOutlet weak var bankNameLabel: UILabel!
    @IBOutlet weak var bankExpandIndicator: UIImageView!
    
    var controller: BanksListViewController?
    var currentFootswitch: Footswitch?
    var currentBank: Bank = Bank(id: "", name: "")
    
    var isExpand = false
    
    func configure(bank: Bank) {
        self.currentBank = bank
        bankNameLabel.text = bank.name
        bankPresetsCollectionView.reloadData()
        if isExpand {
            bankExpandIndicator.image = UIImage(named: "ic_keyboard_arrow_up_48px")
        } else {
            bankExpandIndicator.image = UIImage(named: "ic_keyboard_arrow_down_48px-1")
        }
    }
    
    @IBAction func openBankEditor(_ sender: UIButton) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "FootswitchEdit", bundle: nil)
        guard let desVC = mainStoryboard.instantiateViewController(withIdentifier: "FootswitchEditViewController") as? FootswitchEditViewController else {
            return
        }
        
        desVC.currentFootswitch = self.currentFootswitch
        desVC.currentBank = self.currentBank
        desVC.currentFootswitch?.selectedBank = currentBank
        controller?.show(desVC, sender: nil)
    }
    
    
}

extension BanksListCollectionViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let presets = currentBank.presets
        var actualPresetCount = 0
        for preset in presets {
            if preset.id != nil, preset.id != "" {
                actualPresetCount += 1
            }
        }
        return actualPresetCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PresetsListCell", for: indexPath) as? PresetsListCollectionViewCell else {
            return UICollectionViewCell()
        }
        var actualPresets = currentBank.presets.filter{ $0.id != nil}
        actualPresets = actualPresets.filter { $0.id != ""}
        let actualPreset = currentFootswitch?.presets.first{ $0.id == actualPresets[indexPath.row].id}
        guard let preset = actualPreset else {
            return UICollectionViewCell()
        }
        cell.configure(preset: preset)
        return cell
       
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "PresetSettings", bundle: nil)
        guard let desVC = mainStoryboard.instantiateViewController(withIdentifier: "PresetSettingViewController") as? PresetSettingViewController else {
            return
        }
        guard let preset = ((currentFootswitch?.presets.first{ $0.id == currentBank.presets[indexPath.row].id})) else {
            return
        }
        desVC.currentPreset = preset
        controller?.show(desVC, sender: nil)
    }
    
}
