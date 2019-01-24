//
//  BricksCollectionController.swift
//  BricksMaster
//
//  Created by Kirill Shteffen on 24/01/2019.
//  Copyright © 2019 BlackBricks. All rights reserved.
//

import Foundation


class BricksCollectionController: NSObject {
    
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

extension BricksCollectionController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //guard let footswitch = self.footswitch else { return 0 }
        return footswitch.bricks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FootswitchBricksCollectionViewCell", for: indexPath) as? FootswitchBricksCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(brick: footswitch.bricks[indexPath.row])
        
        return cell
    }
    
}
