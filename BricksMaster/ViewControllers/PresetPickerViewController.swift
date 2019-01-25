//
//  PresetPickerViewController.swift
//  BricksMaster
//
//  Created by Kirill Shteffen on 17/01/2019.
//  Copyright © 2019 BlackBricks. All rights reserved.
//

import UIKit

class PresetPickerViewController: UIViewController {
    
    var editedFootswitch: Footswitch?
    var editedBank: Bank?
    var footswitchButtonNumber = 0
    
    var completion: (()->Void)?
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var shadow: UIView!
    @IBOutlet weak var mainView: UIView!

    
    @IBAction func closePresetPicker(_ sender: UIButton) {
        close()
    }
    
    func close() {
        completion?()
        UIView.animate(withDuration: 0.4, animations: {
            self.shadow.alpha = 0.0
            var frame = self.mainView.frame
            frame.origin.y = self.view.bounds.height
            self.mainView.frame = frame
        }, completion: { selected in
            self.dismiss(animated: false, completion: nil)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shadow.alpha = 0.0
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.4, animations: {
            self.shadow.alpha = 0.45
            var frame = self.mainView.frame
            frame.origin.y = self.view.bounds.height - 500
            self.mainView.frame = frame
        }, completion: nil)
    }
    
}
extension PresetPickerViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return editedFootswitch?.presets.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PresetPickerCell", for: indexPath) as? PresetPickerCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.controller = self
        cell.footswitch = editedFootswitch
        cell.bank = editedBank
        cell.footswitchButtonIndex = footswitchButtonNumber
        if let currentPreset = editedFootswitch?.presets[indexPath.row] {
            cell.configure(preset: currentPreset)
        }
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        
//    }
    
}
