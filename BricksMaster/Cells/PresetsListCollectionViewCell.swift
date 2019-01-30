//
//  PresetsListCollectionViewCell.swift
//  BricksMaster
//
//  Created by Kirill Shteffen on 17/01/2019.
//  Copyright © 2019 BlackBricks. All rights reserved.
//

import UIKit

class PresetsListCollectionViewCell: UICollectionViewCell {
    
    var preset: Preset?
    //var bank: Bank?
    
    @IBOutlet weak var presetName: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var newName: UILabel!
    @IBOutlet weak var bricksIndicatorsView: UIView!
    
    var borderView: CAShapeLayer = CAShapeLayer()
    
    func configure(preset: Preset) {
        self.preset = preset
        button.isHidden = false
        newName.isHidden = true
        presetName.isHidden = false
        borderView.isHidden = true
        presetName.text = preset.name
        let indicators: [UIView] = bricksIndicatorsView.subviews
        let presetBricks = preset.presetTestBricks
        for indicator in indicators {
            indicator.layer.cornerRadius = indicator.frame.width/2
        }
        for index in 0..<presetBricks.count {
            if index < indicators.count, !presetBricks.isEmpty {
                indicators[index].backgroundColor = presetBricks[index].color
                }
            }
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
    
//    func configure(bank: Bank) {
//        self.bank = bank
//        presetName.text = bank.name
//        if(bank.empty) {
//            button.isHidden = true
//            newName.isHidden = false
//            presetName.isHidden = true
//            borderView.isHidden = false
//        } else {
//            button.isHidden = false
//            newName.isHidden = true
//            presetName.isHidden = false
//            borderView.isHidden = true
//        
//        }
//    }
}
