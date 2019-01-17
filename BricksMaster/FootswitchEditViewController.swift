//
//  FootswitchEditViewController.swift
//  BricksMaster
//
//  Created by Kirill Shteffen on 16/01/2019.
//  Copyright © 2019 BlackBricks. All rights reserved.
//

import UIKit

class FootswitchEditViewController: UIViewController {
    
    
    @IBOutlet weak var firstPresetButtonView: UIView!
    @IBOutlet weak var secondPresetButtonView: UIView!
    @IBOutlet weak var thirdPresetButtonView: UIView!
    @IBOutlet weak var fourthPresetButtonView: UIView!
    
    
    
    @IBAction func closeEditController(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func openPresetPicker(_ sender: UIButton) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let desVC = mainStoryboard.instantiateViewController(withIdentifier: "PresetPickerViewController") as? PresetPickerViewController else {
            return
        }
        show(desVC, sender: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
    }
    
    func configurePresetButtons() {
        
    }
    
}

