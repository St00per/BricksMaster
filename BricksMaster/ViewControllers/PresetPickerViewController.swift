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
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var shadow: UICollectionView!

    
    @IBAction func closePresetPicker(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
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
