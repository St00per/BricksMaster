//
//  BanksListViewController.swift
//  BricksMaster
//
//  Created by Kirill Shteffen on 30/01/2019.
//  Copyright © 2019 BlackBricks. All rights reserved.
//

import UIKit

class BanksListViewController: UIViewController {

    
    @IBOutlet weak var banksCollectionView: UICollectionView!
    @IBOutlet var bankNameView: UIView!
    @IBOutlet weak var bankNameTextField: UITextField!
    
    var currentFootswitch: Footswitch?
    var selectedBanksIndex: [IndexPath] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        bankNameTextField.delegate = self
        bankNameTextField.returnKeyType = UIReturnKeyType.done
        self.banksCollectionView.register(UINib(nibName: "NewBankPresetCell", bundle: nil), forCellWithReuseIdentifier: "NewBankPresetCell")
        
    }
    
    @IBAction func createNewBank(_ sender: UIButton) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "FootswitchEdit", bundle: nil)
        guard let currentFootswitch = self.currentFootswitch, let desVC = mainStoryboard.instantiateViewController(withIdentifier: "FootswitchEditViewController") as? FootswitchEditViewController else {
            return
        }

        let newBank: Bank = Bank(id: UUID().uuidString, name: bankNameTextField.text ?? "Unnamed")
        currentFootswitch.banks.append(newBank)
        desVC.currentFootswitch = currentFootswitch
        bankNameView.removeFromSuperview()
        //presetsView.alpha = 1
        //presetsView.isUserInteractionEnabled = true
        show(desVC, sender: nil)
    }
}
extension BanksListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let footswitches = UserDevicesManager.default.userFootswitches//.filter{$0.new == false}
        return footswitches.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let footswitches = UserDevicesManager.default.userFootswitches//.filter{$0.new == false}
        
        if collectionView == banksCollectionView {
            if footswitches[section].banks.count < 4 {
                return footswitches[section].banks.count + 1
            }
            if footswitches[section].banks.count == 4 {
                return footswitches[section].banks.count
            }
        }
        return 0
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
        
        
        if collectionView == banksCollectionView {
            
            if indexPath.row < UserDevicesManager.default.userFootswitches[indexPath.section].banks.count {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BanksListCollectionViewCell", for: indexPath) as? BanksListCollectionViewCell else {
                    return UICollectionViewCell()
                }
                let bank = footswitches[indexPath.section].banks[indexPath.row]
                //cell.configure(bank: bank)
                
                
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.selectedBanksIndex.contains(indexPath)  {
            return CGSize(width: collectionView.frame.width - 20, height: 300)
        }
        return CGSize(width: collectionView.frame.width - 20, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let footswitches = UserDevicesManager.default.userFootswitches//.filter{$0.new == false}
       
        self.currentFootswitch = footswitches[indexPath.section]
        
        if collectionView == banksCollectionView {
            footswitches[indexPath.section]
            if indexPath.row > footswitches[indexPath.section].banks.count - 1 {
                //presetsView.alpha = 0.4
                //presetsView.isUserInteractionEnabled = false
                self.view.addSubview(bankNameView)
                bankNameView.center = self.view.center
            } else {
                if !self.selectedBanksIndex.contains(indexPath) {
                    self.selectedBanksIndex.append(indexPath)
                    UIView.transition(with: collectionView,
                                      duration: 0.35,
                                      options: [],
                                      animations: { self.banksCollectionView.reloadItems(at: self.selectedBanksIndex) })
                } else {
                    self.selectedBanksIndex = self.selectedBanksIndex.filter{ $0 != indexPath }
                    
                }
                UIView.transition(with: collectionView,
                                  duration: 0.35,
                                  options: [],
                                  animations: { self.banksCollectionView.reloadItems(at: self.selectedBanksIndex) })
                                    //reloadItems(at: self.selectedBanksIndex) })
//                let cell = collectionView.cellForItem(at: indexPath)
//
//
//
//                UIView.transition(with: self.view, duration: 0.3, options: UIView.AnimationOptions.curveEaseInOut, animations: {
//
//                    cell?.frame.size.height = 300
//
//
//                }, completion: { (finished: Bool) -> () in
//                })
                
//                let mainStoryboard: UIStoryboard = UIStoryboard(name: "FootswitchEdit", bundle: nil)
//                guard let desVC = mainStoryboard.instantiateViewController(withIdentifier: "FootswitchEditViewController") as? FootswitchEditViewController else {
//                    return
//                }
//                desVC.currentFootswitch = footswitches[indexPath.section]
//                desVC.currentBank = footswitches[indexPath.section].banks.first
//                show(desVC, sender: nil)
            }
        }
    }
}
extension BanksListViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let footswitches = UserDevicesManager.default.userFootswitches//.filter{$0.new == false}
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
