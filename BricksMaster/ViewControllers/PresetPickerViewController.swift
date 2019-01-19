//
//  PresetPickerViewController.swift
//  BricksMaster
//
//  Created by Kirill Shteffen on 17/01/2019.
//  Copyright © 2019 BlackBricks. All rights reserved.
//

import UIKit

class PresetPickerViewController: UIViewController {

    var footswitchButtonNumber = 0
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func closePresetPicker(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
}
extension PresetPickerViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return UserDevicesManager.default.userPresets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PresetPickerCell", for: indexPath) as? PresetPickerCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.controller = self
        cell.footswitchButtonIndex = footswitchButtonNumber
        let currentPreset = UserDevicesManager.default.userPresets[indexPath.row]
        cell.configure(preset: currentPreset)
        return cell
    }
}
