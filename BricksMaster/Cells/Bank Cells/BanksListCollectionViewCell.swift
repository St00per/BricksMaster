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
        controller?.show(desVC, sender: nil)
    }
    
    
}

extension BanksListCollectionViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentBank.presets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PresetsListCell", for: indexPath) as? PresetsListCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(preset: currentBank.presets[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let footswitches = UserDevicesManager.default.userFootswitches//.filter{$0.new == false}
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "PresetSettings", bundle: nil)
        guard let desVC = mainStoryboard.instantiateViewController(withIdentifier: "PresetSettingViewController") as? PresetSettingViewController else {
            return
        }
        desVC.currentPreset = footswitches[indexPath.section].presets[indexPath.row]
        controller?.show(desVC, sender: nil)
    }
    
}
