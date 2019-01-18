//
//  BankCell.swift
//  BricksMaster
//
//  Created by Вячеслав Казаков on 19.01.2019.
//  Copyright © 2019 BlackBricks. All rights reserved.
//

import Foundation
import UIKit

class BankCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    var bank: Bank?
    
    func configure(bank: Bank) {
        self.bank = bank
        nameLabel.text = bank.name
    }
}
