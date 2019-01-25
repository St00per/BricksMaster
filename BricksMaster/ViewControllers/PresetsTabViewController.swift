//
//  PresetsTabViewController.swift
//  BricksMaster
//
//  Created by Kirill Shteffen on 17/01/2019.
//  Copyright © 2019 BlackBricks. All rights reserved.
//

import UIKit

class PresetsTabViewController: UIViewController {
    
    enum CollState {
        case presets
        case banks
    }
    
    var collectionViewState: CollState = .presets
    var currentFootswitch: Footswitch?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var createNewPresetButton: UIView!
    @IBOutlet weak var presetsView: UIView!
    
    @IBOutlet var bankNameView: UIView!
    @IBOutlet weak var bankNameTextField: UITextField!
    
     @IBOutlet var presetsButton: UIButton!
     @IBOutlet var banksButton: UIButton!
    var selectedButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bankNameTextField.delegate = self
        bankNameTextField.returnKeyType = UIReturnKeyType.done
        self.collectionView.register(UINib(nibName: "NewBankPresetCell", bundle: nil), forCellWithReuseIdentifier: "NewBankPresetCell")
        selectedButton = presetsButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(true)
        collectionView.reloadData()
    }
    
    @IBAction func showPresetSetting(_ sender: UIButton) {
        if collectionViewState == .presets {
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "PresetSettings", bundle: nil)
            guard let desVC = mainStoryboard.instantiateViewController(withIdentifier: "PresetSettingViewController") as? PresetSettingViewController else {
                return
            }
            show(desVC, sender: nil)
        }
        
        if collectionViewState == .banks {
            presetsView.alpha = 0.4
            presetsView.isUserInteractionEnabled = false
            self.view.addSubview(bankNameView)
            bankNameView.center = self.view.center
            
        }
    }
    
    @IBAction func showPresets(_ sender: UIButton) {
        selectedButton?.setTitleColor(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), for: .normal)
        presetsButton?.setTitleColor(#colorLiteral(red: 0.2558659911, green: 0.2558728456, blue: 0.2558691502, alpha: 1), for: .normal)
        selectedButton = presetsButton
        createNewPresetButton.isHidden = false
        collectionViewState = .presets
        collectionView.reloadData()
    }
    
    @IBAction func showBanks(_ sender: UIButton) {
        
        selectedButton?.setTitleColor(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), for: .normal)
        banksButton?.setTitleColor(#colorLiteral(red: 0.2558659911, green: 0.2558728456, blue: 0.2558691502, alpha: 1), for: .normal)
        selectedButton = banksButton
        
        createNewPresetButton.isHidden = true
        collectionViewState = .banks
        collectionView.reloadData()
    }
    
    
    @IBAction func closeBankNameView(_ sender: UIButton) {
        bankNameView.removeFromSuperview()
        presetsView.alpha = 1
        presetsView.isUserInteractionEnabled = true
    }
    
    @IBAction func createNewBank(_ sender: UIButton) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let currentFootswitch = self.currentFootswitch, let desVC = mainStoryboard.instantiateViewController(withIdentifier: "FootswitchEditViewController") as? FootswitchEditViewController else {
            return
        }
        
        let newBank: Bank = Bank(id: UUID().uuidString, name: bankNameTextField.text ?? "Unnamed")
        currentFootswitch.banks.append(newBank)
        desVC.currentFootswitch = currentFootswitch
        bankNameView.removeFromSuperview()
        presetsView.alpha = 1
        presetsView.isUserInteractionEnabled = true
        show(desVC, sender: nil)
    }
    
    
}
extension PresetsTabViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let footswitches = UserDevicesManager.default.userFootswitches.filter{$0.new == false}
        return footswitches.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let footswitches = UserDevicesManager.default.userFootswitches.filter{$0.new == false}
        if collectionViewState == .presets {
            return footswitches[section].presets.count
        }
        
        if collectionViewState == .banks {
                return footswitches[section].banks.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footswitches = UserDevicesManager.default.userFootswitches.filter{$0.new == false}
        guard let sectionHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeaderView", for: indexPath) as? SectionHeaderView else {
            return UICollectionReusableView()
        }
        
        sectionHeaderView.footswitchName = footswitches[indexPath.section].name
        return sectionHeaderView
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let footswitches = UserDevicesManager.default.userFootswitches.filter{$0.new == false}

        if collectionViewState == .presets {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PresetsTabCell", for: indexPath) as? PresetsTabCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(preset: footswitches[indexPath.section].presets[indexPath.row])
            return cell
        }
        
        if collectionViewState == .banks {
            
            if indexPath.row < UserDevicesManager.default.userFootswitches[indexPath.section].banks.count {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PresetsTabCell", for: indexPath) as? PresetsTabCollectionViewCell else {
                    return UICollectionViewCell()
                }
                let bank = footswitches[indexPath.section].banks[indexPath.row]
                cell.configure(bank: bank)
                return cell
            } else {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewBankPresetCell", for: indexPath) as? NewBankCollectionViewCell else {
                    return UICollectionViewCell()
                }
                cell.configure()
                return cell
            }
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let footswitches = UserDevicesManager.default.userFootswitches.filter{$0.new == false}
        if collectionViewState == .presets {
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            guard let desVC = mainStoryboard.instantiateViewController(withIdentifier: "PresetSettingViewController") as? PresetSettingViewController else {
                return
            }
            desVC.preset = footswitches[indexPath.section].presets[indexPath.row]
            show(desVC, sender: nil)
        }
        
        if collectionViewState == .banks {
            self.currentFootswitch = footswitches[indexPath.section]
            if indexPath.row > footswitches[indexPath.section].banks.count - 1 {
                presetsView.alpha = 0.4
                presetsView.isUserInteractionEnabled = false
                self.view.addSubview(bankNameView)
                bankNameView.center = self.view.center
            } else {
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            guard let desVC = mainStoryboard.instantiateViewController(withIdentifier: "FootswitchEditViewController") as? FootswitchEditViewController else {
                return
            }
            desVC.currentFootswitch = self.currentFootswitch
            desVC.currentBank = self.currentFootswitch?.banks.first
            show(desVC, sender: nil)
            }
        }
    }
}
extension PresetsTabViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let footswitches = UserDevicesManager.default.userFootswitches.filter{$0.new == false}
        bankNameTextField.resignFirstResponder()
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let desVC = mainStoryboard.instantiateViewController(withIdentifier: "FootswitchEditViewController") as? FootswitchEditViewController else {
            return false
        }
        let newBank: Bank = Bank(id: UUID().uuidString, name: bankNameTextField.text ?? "Unnamed")
        footswitches.first?.banks.append(newBank)
        desVC.currentFootswitch = footswitches.first
        
        show(desVC, sender: nil)
        return true
    }
}
