//
//  ConnectionObserver.swift
//  BricksMaster
//
//  Created by Вячеслав Казаков on 19.01.2019.
//  Copyright © 2019 BlackBricks. All rights reserved.
//

import Foundation

protocol ConnectionObserver: class {
    func brickConnectionStateChanged(connected: Bool, peripheralId: UUID)
    func footswitchConnectionStateChanged(connected: Bool, peripheralId: UUID)
}
