//
//  PresetsListViewController.swift
//  BricksMaster
//
//  Created by Kirill Shteffen on 29/01/2019.
//  Copyright © 2019 BlackBricks. All rights reserved.
//

import UIKit

class PresetsListViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.register(UINib(nibName: "NewBankPresetCell", bundle: nil), forCellWithReuseIdentifier: "NewBankPresetCell")
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        collectionView.reloadData()
    }
    
    @IBAction func createNewPreset(_ sender: UIButton) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "PresetSettings", bundle: nil)
        guard let desVC = mainStoryboard.instantiateViewController(withIdentifier: "PresetSettingViewController") as? PresetSettingViewController else {
            return
        }
        show(desVC, sender: nil)
        }
    }

extension PresetsListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let footswitches = UserDevicesManager.default.userFootswitches//.filter{$0.new == false}
        return footswitches.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let footswitches = UserDevicesManager.default.userFootswitches//.filter{$0.new == false}
        return footswitches[section].presets.count
     
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footswitches = UserDevicesManager.default.userFootswitches//.filter{$0.new == false}
        guard let sectionHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeaderView", for: indexPath) as? SectionHeaderView else {
            return UICollectionReusableView()
        }
        
        sectionHeaderView.footswitchName = footswitches[indexPath.section].name
        return sectionHeaderView
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let footswitches = UserDevicesManager.default.userFootswitches//.filter{$0.new == false}
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PresetsTabCell", for: indexPath) as? PresetsTabCollectionViewCell else {
                return UICollectionViewCell()
            }
        cell.configure(preset: footswitches[indexPath.section].presets[indexPath.row])
            return cell
        }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let footswitches = UserDevicesManager.default.userFootswitches//.filter{$0.new == false}
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            guard let desVC = mainStoryboard.instantiateViewController(withIdentifier: "PresetSettingViewController") as? PresetSettingViewController else {
                return
            }
            desVC.preset = footswitches[indexPath.section].presets[indexPath.row]
            show(desVC, sender: nil)
    }
}
