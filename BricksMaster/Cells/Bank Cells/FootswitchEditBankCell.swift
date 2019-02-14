//
//  FootswitchEditBankCell.swift
//  BricksMaster
//
//  Created by Вячеслав Казаков on 24.01.2019.
//  Copyright © 2019 BlackBricks. All rights reserved.
//

import Foundation

class  FootswitchEditBankCell: UICollectionViewCell {
    
    var borderView: CAShapeLayer = CAShapeLayer()
    var longPressRecognizer: UILongPressGestureRecognizer?
    var bank: Bank?
    var isCurrent: Bool = false
    weak var delegate: BanksControllerDelegate?
    
    @IBOutlet weak var plusImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var colorView: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        borderView.strokeColor = UIColor.black.cgColor
        borderView.lineDashPattern = [2, 2]
        borderView.fillColor = nil
        self.layer.addSublayer(borderView)
        self.layer.cornerRadius = 4
        self.layer.masksToBounds  = true
        
        self.longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(openRenameDeleteView))
        longPressRecognizer?.minimumPressDuration = 0.5
        guard let recognizer = longPressRecognizer else { return }
        self.addGestureRecognizer(recognizer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        borderView.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: 4).cgPath
        borderView.frame = self.bounds
    }
    
    func configure(bank: Bank) {
        self.bank = bank
        if(bank.empty) {
            plusImage.isHidden = false
            nameLabel.isHidden = true
            borderView.isHidden = false
        } else {
            plusImage.isHidden = true
            nameLabel.isHidden = false
            nameLabel.text = bank.name
            borderView.isHidden = true
            
            if isSelected {
                self.colorView.backgroundColor = UIColor(red: 107 / 255.0, green: 155 / 255.0, blue: 212.0 / 255.0, alpha: 1.0)
                self.nameLabel.textColor = UIColor.white
            } else {
                self.colorView.backgroundColor = UIColor(red: 107 / 255.0, green: 155 / 255.0, blue: 212.0 / 255.0, alpha: 0.07)
                self.nameLabel.textColor = UIColor(red: 50.0 / 255.0, green: 50.0 / 255.0, blue: 50.0 / 255.0, alpha: 1.0)
            }
        }
    }

    @objc func openRenameDeleteView() {
        guard self.bank?.empty == false else { return }
        if longPressRecognizer?.state == .began {
            guard let currentBank = self.bank else { return }
            delegate?.selectedBank(bank: currentBank)
        }
        longPressRecognizer?.state = .ended
        delegate?.openRenameDeleteView()
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.colorView.backgroundColor = UIColor(red: 107 / 255.0, green: 155 / 255.0, blue: 212.0 / 255.0, alpha: 1.0)
                self.nameLabel.textColor = UIColor.white
            } else {
                self.colorView.backgroundColor = UIColor(red: 107 / 255.0, green: 155 / 255.0, blue: 212.0 / 255.0, alpha: 0.07)
                self.nameLabel.textColor = UIColor(red: 50.0 / 255.0, green: 50.0 / 255.0, blue: 50.0 / 255.0, alpha: 1.0)
            }
        }
    }
    
}
