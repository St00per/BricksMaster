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
    @IBOutlet var banksListView: UIView!
    
    @IBOutlet var bankNameView: UIView!
    @IBOutlet weak var bankNameTextField: UITextField!
    
    var currentFootswitch: Footswitch?
    var selectedBanksIndex: [IndexPath] = []
    var collapsedCellIndex = [IndexPath()]
    
    var shadowView = UIView(frame: UIScreen.main.bounds)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        shadowView.backgroundColor = UIColor.black
        shadowView.alpha = 0.0
        let shadowViewGesture = UITapGestureRecognizer(target: self, action: #selector(closeBankNameView))
        shadowView.addGestureRecognizer(shadowViewGesture)
        
        self.view.addSubview(shadowView)
        
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
        
        show(desVC, sender: nil)
    }
    
    func openBankNameView() {
        banksCollectionView.isUserInteractionEnabled = false
        self.view.addSubview(bankNameView)
        let size = CGSize(width: self.view.bounds.width * 0.9, height: 190)
        let bankNameViewFrame = CGRect(x: self.view.bounds.width * 0.05, y: self.view.bounds.height, width: size.width, height: size.height)
        self.bankNameView.frame = bankNameViewFrame
        
        UIView.animate(withDuration: 0.3, animations: {
            self.shadowView.alpha = 0.45
            self.bankNameView.frame = CGRect(x: bankNameViewFrame.origin.x, y: self.view.bounds.midY - 120, width: size.width, height: size.height)
        }) { (isFinished) in
            self.becomeFirstResponder()
        }
        
    }
    
    @objc func closeBankNameView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.shadowView.alpha = 0.0
            let size = CGSize(width: self.view.bounds.width * 0.9, height: 190)
            self.bankNameView.frame = CGRect(x: self.view.bounds.width * 0.05, y: self.view.bounds.height, width: size.width, height: size.height)
        }) { (isFinished) in
            self.becomeFirstResponder()
            self.banksCollectionView.isUserInteractionEnabled = true
            self.bankNameView.removeFromSuperview()
        }
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
                
                if self.selectedBanksIndex.contains(indexPath) {
                    cell.isExpand = true
                } else {
                    cell.isExpand = false
                }

                cell.configure(bank: bank)
                return cell
            } else {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewBankPresetCell", for: indexPath) as? NewBankCollectionViewCell else {
                    return UICollectionViewCell()
                }
                cell.configure(width: cell.frame.width)
                return cell
            }
        }
  
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.selectedBanksIndex.contains(indexPath)  {
            let bankPresetCount = CGFloat(UserDevicesManager.default.userFootswitches[indexPath.section].banks[indexPath.row].presets.count)
            var expandedCellHeight: CGFloat = 80
            if bankPresetCount > 0 {
                expandedCellHeight = expandedCellHeight + (expandedCellHeight * bankPresetCount) + 16
            }
            return CGSize(width: collectionView.frame.width - 50, height: expandedCellHeight)
        }
        return CGSize(width: collectionView.frame.width - 50, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let footswitches = UserDevicesManager.default.userFootswitches//.filter{$0.new == false}

        self.currentFootswitch = footswitches[indexPath.section]

        if collectionView == banksCollectionView {
            if indexPath.row > footswitches[indexPath.section].banks.count - 1 {
                
                openBankNameView()
            } else {
                if !self.selectedBanksIndex.contains(indexPath) {
                    self.selectedBanksIndex.append(indexPath)
                    self.banksCollectionView.reloadItems(at: self.selectedBanksIndex)
                } else {
                    self.selectedBanksIndex = self.selectedBanksIndex.filter{ $0 != indexPath }
                    self.collapsedCellIndex[0] = indexPath
                    self.banksCollectionView.reloadItems(at: self.collapsedCellIndex)
                    self.banksCollectionView.reloadItems(at: self.selectedBanksIndex)
                }
            }
        }
    }
}
extension BanksListViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let footswitches = UserDevicesManager.default.userFootswitches//.filter{$0.new == false}
        bankNameTextField.resignFirstResponder()
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "FootswitchEdit", bundle: nil)
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
