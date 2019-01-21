//
//  DebugViewController.swift
//  BricksMaster
//
//  Created by Вячеслав Казаков on 20.01.2019.
//  Copyright © 2019 BlackBricks. All rights reserved.
//

import Foundation
import UIKit

class DebugController {
    static let shared: DebugController = DebugController()
    var debugString: String = ""
    var controller: DebugViewController?
    
    class func addLog(_ text: String) {
        DebugController.shared.debugString += text + "\n";
        if let controller =  DebugController.shared.controller {
            controller.textView.text = DebugController.shared.debugString
        }
    }
}

class DebugViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.text = DebugController.shared.debugString
        DebugController.shared.controller = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}
