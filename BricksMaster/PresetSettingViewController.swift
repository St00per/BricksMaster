//
//  PresetSettingViewController.swift
//  BricksMaster
//
//  Created by Kirill Shteffen on 17/01/2019.
//  Copyright © 2019 BlackBricks. All rights reserved.
//

import UIKit

class PresetSettingViewController: UIViewController {

    @IBAction func closePresetSetting(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func showFootswitchPicker(_ sender: UIButton) {
        
    }
    
    @IBAction func showBrickPicker(_ sender: UIButton) {
        
    }
    
    
    @IBAction func savePreset(_ sender: UIButton) {
        
    }
    
    
    @IBOutlet weak var presetNameTextField: UITextField!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
extension PresetSettingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return UserDevicesManager.default.userBricks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PresetSettingsBrickCell", for: indexPath) as? PresetSettingBricksCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(brick: UserDevicesManager.default.userBricks[indexPath.row])
        return cell
    }
}
