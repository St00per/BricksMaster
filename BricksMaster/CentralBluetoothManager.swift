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
let brickModuleFunctionConfigurationCBUUID = CBUUID(string: "FFE2")

let footswitchesServiceCBUUID = CBUUID(string: "6E400001-B5A3-F393-E0A9-E50E24DCCA9E")
let footswitchRxCharacteristic = CBUUID(string: "6E400003-B5A3-F393-E0A9-E50E24DCCA9E")
let footswitchTxCharacteristic = CBUUID(string: "6E400002-B5A3-F393-E0A9-E50E24DCCA9E")

protocol PinIOModuleManagerDelegate: class {
    //func onPinIODidEndPinQuery(isDefaultConfigurationAssumed: Bool)
    func onPinIODidReceivePinState()
}

struct TxCommand {
    let data: Data
    let peripheral: CBPeripheral
    let characteristic: CBCharacteristic
}

public func println(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    let output = items.map { "\($0)" }.joined(separator: separator)
    DebugController.addLog(output)
    Swift.print(items, terminator: terminator)
}

class CentralBluetoothManager: NSObject {
    
    public static let `default` = CentralBluetoothManager()
    
    var centralManager: CBCentralManager!
    
    var devicesTabViewController: DevicesTabViewController?
    var delegate: PinIOModuleManagerDelegate?
    var foundBricks: [CBPeripheral] = []
    var bricksCharacteristic: CBCharacteristic!
    
    var foundFootswitches: [CBPeripheral] = []
    var footswitchesCharacteristic: CBCharacteristic!
    
    var commandQueue: [TxCommand] = []
    var txReady: Bool = true
    
    var digitalIDs = [2:0,3:1,5:2,6:3,9:4]
    
    var connectQueue: [Observable] = []
    
    private let SYSEX_START: UInt8 = 0xF0
    private let SYSEX_END: UInt8 = 0xF7
    
    var isFirstDidLoad = true
    var isFirstSend = true
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
    }
    
    private func updatePinsForReceivedStates(_ pinStates: Int, port: Int, footSwitch: Footswitch?) {
        let offset = 8 * port
        // Iterate through all pins
        if let footSwitch = footSwitch {
            var selectedId = -1
            for i in 0...7 {
                let mask = 1 << i
                let state = (pinStates & mask) >> i
                if let digitalId = digitalIDs[offset + i] {
                    if digitalId < 4 {
                        if !footSwitch.buttons[digitalId].isOn && (state == 0) {
                            selectedId = digitalId
                        }
                    } else {
                        if state == 0 {
                            //footSwitch.customButton.
                        }
                    }
                }
                println("[\(i) - \(state)]\t")
            }
            if selectedId != -1{
                for i in 0...3 {
                    footSwitch.buttons[i].isOn = i == selectedId
                    if footSwitch.buttons[i].isOn {
                        footSwitch.selectedPreset = footSwitch.buttons[i].preset
                    }
                }
            }
            UserDevicesManager.default.updateFootswitch(footswitch: footSwitch)
            println("\n")
        }
    }
    
    private var receivedPinStateDataBuffer = [UInt8]()
    fileprivate func receivedPinState(data: Data, footSwitch: Footswitch?) {
        
        // Append received bytes to buffer
        var receivedDataBytes = [UInt8](repeating: 0, count: data.count)
        data.copyBytes(to: &receivedDataBytes, count: data.count)
        for byte in receivedDataBytes {
            receivedPinStateDataBuffer.append(byte)
        }
        
        // Check if we received a pin state response
        let endIndex = receivedPinStateDataBuffer.index(of: SYSEX_END)
        if receivedPinStateDataBuffer.count >= 5 && receivedPinStateDataBuffer[0] == SYSEX_START && receivedPinStateDataBuffer[1] == 0x6e && endIndex != nil {
            /* pin state response
             * -------------------------------
             * 0  START_SYSEX (0xF0) (MIDI System Exclusive)
             * 1  pin state response (0x6E)
             * 2  pin (0 to 127)
             * 3  pin mode (the currently configured mode)
             * 4  pin state, bits 0-6
             * 5  (optional) pin state, bits 7-13
             * 6  (optional) pin state, bits 14-20
             ...  additional optional bytes, as many as needed
             * N  END_SYSEX (0xF7)
             */
            // Remove from the buffer the bytes parsed
            if let endIndex = endIndex {
                receivedPinStateDataBuffer.removeFirst(endIndex)
            }
        } else {
            // Each pin state message is 3 bytes long
            var isDigitalReportingMessage = (receivedPinStateDataBuffer[0] >= 0x90) && (receivedPinStateDataBuffer[0] <= 0x9F)
            var isAnalogReportingMessage = (receivedPinStateDataBuffer[0] >= 0xE0) && (receivedPinStateDataBuffer[0] <= 0xEF)
            
            println("receivedPinStateDataBuffer size: \(receivedPinStateDataBuffer.count)")
            
            while receivedPinStateDataBuffer.count >= 3 && (isDigitalReportingMessage || isAnalogReportingMessage)        // Check that current message length is at least 3 bytes
            {
                if isDigitalReportingMessage {             // Digital Reporting (per port)
                    /* two byte digital data format, second nibble of byte 0 gives the port number (e.g. 0x92 is the third port, port 2)
                     * 0  digital data, 0x90-0x9F, (MIDI NoteOn, but different data format)
                     * 1  digital pins 0-6 bitmask
                     * 2  digital pin 7 bitmask
                     */
                    
                    let port = Int(receivedPinStateDataBuffer[0]) - 0x90
                    var pinStates = Int(receivedPinStateDataBuffer[1])
                    pinStates |= Int(receivedPinStateDataBuffer[2]) << 7           // PORT 0: use LSB of third byte for pin7, PORT 1: pins 14 & 15
                    updatePinsForReceivedStates(pinStates, port: port, footSwitch: footSwitch)
                } else if isAnalogReportingMessage {       // Analog Reporting (per pin)
                    return;
                }
                
                // Remove from the buffer the bytes parsed
                receivedPinStateDataBuffer.removeFirst(3)
                
                // Setup vars for next message
                if receivedPinStateDataBuffer.count >= 3 {
                    isDigitalReportingMessage = (receivedPinStateDataBuffer[0] >= 0x90) && (receivedPinStateDataBuffer[0] <= 0x9F)
                    isAnalogReportingMessage = (receivedPinStateDataBuffer[0] >= 0xE0) && (receivedPinStateDataBuffer[0] <= 0xEF)
                } else {
                    isDigitalReportingMessage = false
                    isAnalogReportingMessage = false
                }
            }
        }
    }
    
}

extension CentralBluetoothManager: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
            
        case .unknown:
            println("central.state is .unknown")
        case .resetting:
            println("central.state is .resetting")
        case .unsupported:
            println("central.state is .unsupported")
        case .unauthorized:
            println("central.state is .unauthorized")
        case .poweredOff:
            println("central.state is .poweredOff")
        case .poweredOn:
            println("central.state is .poweredOn")
            if isFirstDidLoad {
                centralManager.scanForPeripherals(withServices: [bricksCBUUID,footswitchesServiceCBUUID])
                
            }
        }
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        println(error)
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        println(peripheral)
        foundFootswitches.append(peripheral)
        //centralManager.connect(foundFootswitches[0])
        
        let uuidArray = advertisementData[CBAdvertisementDataServiceUUIDsKey] as! [CBUUID]
        
        for uuid in uuidArray {
            if uuid == footswitchesServiceCBUUID {
                let newFootswitch = Footswitch(id: peripheral.identifier.uuidString, name: peripheral.name ?? "Unnamed")
                newFootswitch.peripheral = peripheral
                newFootswitch.name = peripheral.name ?? "Unnamed"
                let footswitch = UserDevicesManager.default.footswitch(id: peripheral.identifier.uuidString)
                if let newFootswitch = footswitch {
                    UserDevicesManager.default.connect(footswitch: newFootswitch)
                } else {
                    println("Add footswitch: \(peripheral.identifier)")
                    UserDevicesManager.default.userFootswitches.append(newFootswitch)
                }
            }
            if uuid == bricksCBUUID {
                let brick = Brick(id: peripheral.identifier)
                brick.peripheral = peripheral
                brick.deviceName = peripheral.name
                if UserDevicesManager.default.userBricks.first(where: { (brick) -> Bool in
                    guard let id = brick.id else {
                        return false
                    }
                    return id == peripheral.identifier.uuidString
                }) == nil {
                    UserDevicesManager.default.userBricks.append(brick)
                }
            }
        }
        
        if isFirstDidLoad {
            isFirstDidLoad = false
        }
        
        devicesTabViewController?.bricksCollectionView.reloadData()
        devicesTabViewController?.footswitchesCollectionView.reloadData()
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        devicesTabViewController?.bricksCollectionView.reloadData()
        devicesTabViewController?.footswitchesCollectionView.reloadData()
        println("Connected!")
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        println("Disconnected!")
        if let brick = UserDevicesManager.default.brickForPeripheral(peripheral: peripheral) {
            brick.updateConnection(isConnected: false)
        }
        if let footswitch = UserDevicesManager.default.footswitchByPeripheral(peripheral: peripheral) {
            footswitch.updateConnection(isConnected: false)
        }
        devicesTabViewController?.bricksCollectionView.reloadData()
        devicesTabViewController?.footswitchesCollectionView.reloadData()
    }
    
    func connect(peripheral: CBPeripheral) {
        
//        centralManager.stopScan()
//        println ("Scan stopped, trying to connect")
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
            println(service)
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService,
                    error: Error?) {
        guard let characteristics = service.characteristics else { return }
        let footswitch = UserDevicesManager.default.footswitchByPeripheral(peripheral: peripheral)
        let brick = UserDevicesManager.default.brickForPeripheral(peripheral: peripheral)
        for characteristic in characteristics {
            //println(characteristic)
            
            if characteristic.properties.contains(.write) {
                println("\(characteristic.uuid): properties contains .write")
                if characteristic.uuid == brickModuleFunctionConfigurationCBUUID {
                    CentralBluetoothManager.default.bricksCharacteristic = characteristic
                    if let brick = brick {
                        //TODO: Connect right characteristics
                        brick.tx = characteristic
                    }
                }
            }
            if let footswitch = footswitch {
                if characteristic.uuid == footswitchTxCharacteristic {
                    footswitchesCharacteristic = characteristic
                    footswitch.tx = characteristic
                }
                if characteristic.uuid == footswitchRxCharacteristic {
                    println("\(characteristic.uuid): properties contains .notify")
                    peripheral.setNotifyValue(true, for: characteristic)
                    footswitch.rx = characteristic
                }
            }
        }
        //init footswitch ports if it's full connected
        if let footswitch = footswitch {
            if(footswitch.peripheral != nil && footswitch.rx != nil && footswitch.tx != nil && footswitch.needInitalizePorts) {
                footswitch.needInitalizePorts = false;
                initFootSwitchPorts(footSwitch: footswitch)
            }
        }
        if let observable = connectQueue.first {
            if(observable.checkConnection()){
                observable.saveConnected()
                connectQueue.removeFirst()
                if let nextObservable = connectQueue.first {
                    nextObservable.connect()
                }
            }
        }
    }
    
    func initFootSwitchPorts(footSwitch: Footswitch) {
        guard let peripheral = footSwitch.peripheral, let tx = footSwitch.tx else {
            println("Can't send message");
            return;
        }
        let data0: UInt8 = 0xD0 + 0        // start port 0 digital reporting (0xD0 + port#)
        let data1: UInt8 = 1                  // enable
        var bytes: [UInt8] = [data0, data1]
        var data = Data(bytes: bytes)
        sendCommand(to: peripheral, characteristic: tx, data: data)
        let data2: UInt8 = 0xD0 + 1        // start port 0 digital reporting (0xD0 + port#)
        let data3: UInt8 = 1                  // enable
        bytes = [data2, data3]
        data = Data(bytes: bytes)
        sendCommand(to: peripheral, characteristic: tx, data: data)
        for id in [2,3,5,6,9,10, 21, 22, 23] {
            bytes = [0xf4, UInt8(id), id < 10 ? 0 : 1]
            data = Data(bytes: bytes)
            sendCommand(to: peripheral, characteristic: tx, data: data)
        }
    }
    
    func sendCommand(to peripheral: CBPeripheral, characteristic: CBCharacteristic, data: Data) {
        if(txReady) {
            peripheral.writeValue(data, for: characteristic, type: CBCharacteristicWriteType.withResponse)
        } else {
            let command = TxCommand(data: data, peripheral: peripheral, characteristic: characteristic)
            commandQueue.append(command)
        }
        txReady = false
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic,
                    error: Error?) {
        switch characteristic.uuid {
//        case footswitchFirstTestedCharacteristic:
//            println(characteristic.value ?? "no value")
        case footswitchRxCharacteristic:
            println(characteristic.value ?? "no value")
            guard let characteristicData = characteristic.value else { return }
            receivedPinState(data: characteristicData, footSwitch: UserDevicesManager.default.footswitchByPeripheral(peripheral: peripheral))
        default:
            println("Unhandled Characteristic UUID: \(characteristic.uuid)")
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        guard error == nil else {
            println("Error while sending: \(error?.localizedDescription ?? "")")
            return
        }
        println("Message sent \(peripheral.name ?? "")/\(peripheral.identifier)")
        if(commandQueue.count > 0) {
            println("Queue count: \(commandQueue.count)\n")
            let command = commandQueue.removeFirst()
            command.peripheral.writeValue(command.data, for: command.characteristic, type: CBCharacteristicWriteType.withResponse)
        } else {
            txReady = true
        }
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
