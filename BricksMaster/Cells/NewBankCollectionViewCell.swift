//
//  NewBankCollectionViewCell.swift
//  BricksMaster
//
//  Created by Kirill Shteffen on 23/01/2019.
//  Copyright © 2019 BlackBricks. All rights reserved.
//

import UIKit

class NewBankCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var newBankView: UIView!
    
    func configure() {
       newBankView.addDashedBorder()
    }
}
