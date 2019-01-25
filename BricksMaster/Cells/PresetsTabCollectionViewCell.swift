//
//  PresetsTabCollectionViewCell.swift
//  BricksMaster
//
//  Created by Kirill Shteffen on 17/01/2019.
//  Copyright © 2019 BlackBricks. All rights reserved.
//

import UIKit

class PresetsTabCollectionViewCell: UICollectionViewCell {
    
    var preset: Preset?
    var bank: Bank?
    
    @IBOutlet weak var presetName: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var newName: UILabel!
    
    var borderView: CAShapeLayer = CAShapeLayer()
    
    func configure(preset: Preset) {
        self.preset = preset
        button.isHidden = false
        newName.isHidden = true
        presetName.isHidden = false
        borderView.isHidden = true
        presetName.text = preset.name
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        borderView.strokeColor = UIColor.black.cgColor
        borderView.lineDashPattern = [2, 2]
        borderView.fillColor = nil
        self.layer.addSublayer(borderView)
        self.layer.cornerRadius = 4
        self.layer.masksToBounds  = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        borderView.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: 4).cgPath
        borderView.frame = self.bounds
    }
    
    func configure(bank: Bank) {
        self.bank = bank
        presetName.text = bank.name
        if(bank.empty) {
            button.isHidden = true
            newName.isHidden = false
            presetName.isHidden = true
            borderView.isHidden = false
        } else {
            button.isHidden = false
            newName.isHidden = true
            presetName.isHidden = false
            borderView.isHidden = true
        
        }
    }
}
