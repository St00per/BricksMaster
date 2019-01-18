//
//  FootswitchEditViewController.swift
//  BricksMaster
//
//  Created by Kirill Shteffen on 16/01/2019.
//  Copyright © 2019 BlackBricks. All rights reserved.
//

import UIKit

class FootswitchEditViewController: UIViewController {
    
    
    @IBOutlet weak var presetButtonsView: UIView!
    
    @IBOutlet weak var firstPresetButtonView: UIView!
    @IBOutlet weak var firstPresetButtonLabel: UILabel!
    @IBOutlet weak var firstPresetOnOffButton: UIButton!
    @IBOutlet weak var firstPresetSelectButton: UIButton!
    
    @IBOutlet weak var secondPresetButtonView: UIView!
    @IBOutlet weak var secondPresetButtonLabel: UILabel!
    @IBOutlet weak var secondPresetOnOffButton: UIButton!
    @IBOutlet weak var secondPresetSelectButton: UIButton!
    
    @IBOutlet weak var thirdPresetButtonView: UIView!
    @IBOutlet weak var thirdPresetButtonLabel: UILabel!
    @IBOutlet weak var thirdPresetOnOffButton: UIButton!
    @IBOutlet weak var thirdPresetSelectButton: UIButton!
    
    @IBOutlet weak var fourthPresetButtonView: UIView!
    @IBOutlet weak var fourthPresetButtonLabel: UILabel!
    @IBOutlet weak var fourthPresetOnOffButton: UIButton!
    @IBOutlet weak var fourthPresetSelectButton: UIButton!
    
    
    
    @IBAction func closeEditController(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func openPresetPicker(_ sender: UIButton) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let desVC = mainStoryboard.instantiateViewController(withIdentifier: "PresetPickerViewController") as? PresetPickerViewController else {
            return
        }
        
        switch sender {
        case firstPresetSelectButton:
            desVC.footswitchButtonNumber = 0
        case secondPresetSelectButton:
            desVC.footswitchButtonNumber = 1
        case thirdPresetSelectButton:
            desVC.footswitchButtonNumber = 2
        case fourthPresetSelectButton:
            desVC.footswitchButtonNumber = 3
        default:
            return
        }
        show(desVC, sender: nil)
    }
    
    
    @IBAction func onOffFootswitchButton(_ sender: UIButton) {
        let footswitchButtons = UserDevicesManager.default.userFootswitches[0].buttons

        
        switch sender {
        case firstPresetOnOffButton:
            guard footswitchButtons[0].preset != nil else { return }
            if footswitchButtons[0].isOn == false{
                footswitchButtons[0].isOn = true
                footswitchButtons[1].isOn = false
                footswitchButtons[2].isOn = false
                footswitchButtons[3].isOn = false
            } else {
                for button in footswitchButtons {
                    button.isOn = false
                }
            }
        case secondPresetOnOffButton:
            guard footswitchButtons[1].preset != nil else { return }
            if footswitchButtons[1].isOn == false {
                footswitchButtons[0].isOn = false
                footswitchButtons[1].isOn = true
                footswitchButtons[2].isOn = false
                footswitchButtons[3].isOn = false
            } else {
                for button in footswitchButtons {
                    button.isOn = false
                }
            }
        case thirdPresetOnOffButton:
            guard footswitchButtons[2].preset != nil else { return }
            if footswitchButtons[2].isOn == false {
                footswitchButtons[0].isOn = false
                footswitchButtons[1].isOn = false
                footswitchButtons[2].isOn = true
                footswitchButtons[3].isOn = false
            } else {
                for button in footswitchButtons {
                    button.isOn = false
                }
            }
        case fourthPresetOnOffButton:
            guard footswitchButtons[3].preset != nil else { return }
            if footswitchButtons[3].isOn == false {
                footswitchButtons[0].isOn = false
                footswitchButtons[1].isOn = false
                footswitchButtons[2].isOn = false
                footswitchButtons[3].isOn = true
            } else {
                for button in footswitchButtons {
                    button.isOn = false
                }
            }
        default:
            return
        }
        configurePresetButtons()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        configurePresetButtons()
    }
    
    func configurePresetButtons() {
        let currentFootswitch = UserDevicesManager.default.userFootswitches[0]
        firstPresetButtonLabel.text = currentFootswitch.buttons[0].preset?.name ?? "None"
        secondPresetButtonLabel.text = currentFootswitch.buttons[1].preset?.name ?? "None"
        thirdPresetButtonLabel.text = currentFootswitch.buttons[2].preset?.name ?? "None"
        fourthPresetButtonLabel.text = currentFootswitch.buttons[3].preset?.name ?? "None"
        
        let footswitchButtons = currentFootswitch.buttons
        
        
        if footswitchButtons[0].isOn == true
        {
            firstPresetOnOffButton.setTitle("ON", for: .normal)
            firstPresetOnOffButton.backgroundColor = UIColor.black
            firstPresetButtonView.backgroundColor = UIColor.lightGray
        } else {
            firstPresetOnOffButton.setTitle("OFF", for: .normal)
            firstPresetOnOffButton.backgroundColor = UIColor.lightGray
            firstPresetButtonView.backgroundColor = UIColor(hexString: "EDEDED")
        }
        if footswitchButtons[1].isOn == true
        {
            secondPresetOnOffButton.setTitle("ON", for: .normal)
            secondPresetOnOffButton.backgroundColor = UIColor.black
            secondPresetButtonView.backgroundColor = UIColor.lightGray
        } else {
            secondPresetOnOffButton.setTitle("OFF", for: .normal)
            secondPresetOnOffButton.backgroundColor = UIColor.lightGray
            secondPresetButtonView.backgroundColor = UIColor(hexString: "EDEDED")
        }
        if footswitchButtons[2].isOn == true
        {
            thirdPresetOnOffButton.setTitle("ON", for: .normal)
            thirdPresetOnOffButton.backgroundColor = UIColor.black
            thirdPresetButtonView.backgroundColor = UIColor.lightGray
        } else {
            thirdPresetOnOffButton.setTitle("OFF", for: .normal)
            thirdPresetOnOffButton.backgroundColor = UIColor.lightGray
            thirdPresetButtonView.backgroundColor = UIColor(hexString: "EDEDED")
        }
        if footswitchButtons[3].isOn == true
        {
            fourthPresetOnOffButton.setTitle("ON", for: .normal)
            fourthPresetOnOffButton.backgroundColor = UIColor.black
            fourthPresetButtonView.backgroundColor = UIColor.lightGray
        } else {
            fourthPresetOnOffButton.setTitle("OFF", for: .normal)
            fourthPresetOnOffButton.backgroundColor = UIColor.lightGray
            fourthPresetButtonView.backgroundColor = UIColor(hexString: "EDEDED")
        }
    }
}
extension FootswitchEditViewController: PinIOModuleManagerDelegate {
    
    
    
    func onPinIODidReceivePinState() {
        configurePresetButtons()
    }
    
    
}
