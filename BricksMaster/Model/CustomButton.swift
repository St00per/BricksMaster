//
//  CustomButton.swift
//  DataModel
//
//  Created by Вячеслав Казаков on 14.01.2019.
//  Copyright © 2019 Вячеслав Казаков. All rights reserved.
//

import Foundation
import UIKit

enum CustomButtonAction {
    case nextBank
    case disableAllBricks
}

class CustomButton: NSObject {
    var longTapAction: CustomButtonAction = .nextBank
    var shortTapAction: CustomButtonAction = .disableAllBricks
    
    var longTapTimeout: TimeInterval = 1000.0
    var pendedAction: Bool = false
    var tapTime: TimeInterval?
    var longTapOccures: Bool = false
    
    func startPendedAction() {
        pendedAction = true
        perform(#selector(longTap), with: self, afterDelay: longTapTimeout)
    
    }
    
    func tap() {
        
    }
    
    @objc func longTap() {
        longTapOccures = true
        
        perform(#selector(longTap), with: self, afterDelay: longTapTimeout)
    }
    
    func finishPendedAction() {
        pendedAction = false
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        if !longTapOccures {
            tap()
        } else {
            
        }
    }
}
