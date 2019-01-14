//
//  FootswitchButton.swift
//  DataModel
//
//  Created by Вячеслав Казаков on 14.01.2019.
//  Copyright © 2019 Вячеслав Казаков. All rights reserved.
//

import Foundation

class FootswitchButton {
    var index: Int
    var preset: Preset? = nil
    var isSelected: Bool = false
    
    init(_ index: Int) {
        self.index = index
    }
}
