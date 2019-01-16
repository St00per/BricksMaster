//
//  CentralBluetoothManager.swift
//  BricksMaster
//
//  Created by Kirill Shteffen on 15/01/2019.
//  Copyright © 2019 BlackBricks. All rights reserved.
//

import Foundation
import CoreBluetooth

let bricksCBUUID = CBUUID(string: "0xFFE0")
let footswitchesCBUUID = CBUUID(string: "0xFFE0")
let moduleFunctionConfigurationCBUUID = CBUUID(string: "FFE2")


class CentralBluetoothManager: NSObject {
    
    public static let `default` = CentralBluetoothManager()
    
    var centralManager: CBCentralManager!
    
    var devicesTabViewController: DevicesTabViewController?
    
    var foundBricks: [CBPeripheral] = []
    var bricksCharacteristic: CBCharacteristic!
    
    var foundFootswitches: [CBPeripheral] = []
    var footswitchesCharacteristic: CBCharacteristic!
    
    
    var isFirstDidLoad = true
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
    }
}

extension CentralBluetoothManager: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
            
        case .unknown:
            print("central.state is .unknown")
        case .resetting:
            print("central.state is .resetting")
        case .unsupported:
            print("central.state is .unsupported")
        case .unauthorized:
            print("central.state is .unauthorized")
        case .poweredOff:
            print("central.state is .poweredOff")
        case .poweredOn:
            print("central.state is .poweredOn")
            if isFirstDidLoad {
                centralManager.scanForPeripherals(withServices: [bricksCBUUID])
                
                //centralManager.scanForPeripherals(withServices: [footswitchesCBUUID])
                
            }
        }
        
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print(peripheral)
        let brick = Brick(id: peripheral.identifier)
        brick.peripheral = peripheral
        brick.deviceName = peripheral.name
        
        if !UserDevicesManager.default.userBricks.contains(brick) {
            UserDevicesManager.default.userBricks.append(brick)
        }
        if isFirstDidLoad {
            isFirstDidLoad = false
        }
        print("\(UserDevicesManager.default.userBricks.count) devices have found")
        devicesTabViewController?.bricksCollectionView.reloadData()
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
        print("Connected!")
        peripheral.discoverServices(nil)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Disconnected!")
    }
    
    func connect(peripheral: CBPeripheral) {
        
        centralManager.stopScan()
        print ("Scan stopped, trying to connect")
        peripheral.delegate = self
        centralManager.connect(peripheral)
    }
    
    func disconnect(peripheral: CBPeripheral) {
        centralManager.cancelPeripheralConnection(peripheral)
    }
}

extension CentralBluetoothManager: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        
        for service in services {
            print(service)
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService,
                    error: Error?) {
        guard let characteristics = service.characteristics else { return }
        
        for characteristic in characteristics {
            print(characteristic)
            
            if characteristic.properties.contains(.write) {
                print("\(characteristic.uuid): properties contains .write")
                if characteristic.uuid == moduleFunctionConfigurationCBUUID {
                    CentralBluetoothManager.default.bricksCharacteristic = characteristic
 
                }
            }
        }
    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        guard error == nil else {
            print("Error discovering services: error")
            return
        }
        print("Message sent")
    }
}
//Data commands
extension CentralBluetoothManager {
    
    func OnOff() -> Data {
        
        var dataToWrite = Data()
        dataToWrite.append(0xE8)
        dataToWrite.append(0xA1)
        dataToWrite.append(0x02)
        
        return dataToWrite
    }
    
    func frequency1000() -> Data {
        
        var dataToWrite = Data()
        
        dataToWrite.append(0xE8)
        dataToWrite.append(0xA2)
        dataToWrite.append(0x03)
        dataToWrite.append(0xE8)
        
        return dataToWrite
    }
}
