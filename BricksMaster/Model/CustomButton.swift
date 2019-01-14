//
//  CustomButton.swift
//  DataModel
//
//  Created by Вячеслав Казаков on 14.01.2019.
//  Copyright © 2019 Вячеслав Казаков. All rights reserved.
//

import Foundation

enum CustomButtonAction {
    case nextBank
    case disableAllBricks
}

class CustomButton {
    var longTapAction: CustomButtonAction = .nextBank
    var shortTapAction: CustomButtonAction = .disableAllBricks
}
