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
    
    
}
