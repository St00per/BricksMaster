//
//  Observable.swift
//  BricksMaster
//
//  Created by Вячеслав Казаков on 19.01.2019.
//  Copyright © 2019 BlackBricks. All rights reserved.
//

import Foundation

class Observable: NSObject {
    
    var observers: [ConnectionObserver] = []
    
    func subscribe(observer: ConnectionObserver) {
        observers.append(observer)
    }
    
    func unsubscribe(observer: ConnectionObserver) {
        if let index = observers.firstIndex (where: { (findedObserver) -> Bool in
            let findedObserver = findedObserver as? NSObject
            let observer = observer as? NSObject
            return findedObserver == observer
        })
        {
            observers.remove(at: index)
        }
    }
}
