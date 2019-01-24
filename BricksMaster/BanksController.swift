//
//  BanksController.swift
//  BricksMaster
//
//  Created by Вячеслав Казаков on 24.01.2019.
//  Copyright © 2019 BlackBricks. All rights reserved.
//

import Foundation

protocol BanksControllerDelegate: class {
    func didCreateNew(bank: Bank)
    func selectedBank(bank: Bank)
}

class BanksController : NSObject{
    
    weak var collection: UICollectionView?
    var footswitch: Footswitch
    
    weak var delegate: BanksControllerDelegate?
    
    var selectedFootswitchId: Int = 0
    
    init(collection: UICollectionView, footswitch: Footswitch) {
        self.collection = collection
        self.footswitch = footswitch
        super.init()
        self.collection?.dataSource = self
        self.collection?.delegate = self
    }
    
    func update() {
        collection?.reloadData()
    }
}

extension BanksController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return footswitch.banks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "selectBankCell", for: indexPath)
        if let cell = cell as? FootswitchEditBankCell {
            cell.configure(bank: footswitch.banks[indexPath.item])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width - 3 * 8) / 4  , height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let bank = footswitch.banks[indexPath.item]
        if bank.empty {
            delegate?.didCreateNew(bank: bank)
        } else {
            footswitch.selectedBank = bank
            delegate?.selectedBank(bank: bank)
            footswitch.save()
        }
    }
}

