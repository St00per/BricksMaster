//
//  CentralBluetoothManager.swift
//  BricksMaster
//
//  Created by Kirill Shteffen on 15/01/2019.
//  Copyright © 2019 BlackBricks. All rights reserved.
//

import Foundation
import CoreBluetooth

let bricksCBUUID = CBUUID(string: "0xFFF0")
let footswitchesServiceCBUUID = CBUUID(string: "6E400001-B5A3-F393-E0A9-E50E24DCCA9E")

let footswitchRxCharacteristic = CBUUID(string: "6E400003-B5A3-F393-E0A9-E50E24DCCA9E")
let footswitchTxCharacteristic = CBUUID(string: "6E400002-B5A3-F393-E0A9-E50E24DCCA9E")

let brickModuleFunctionConfigurationCBUUID = CBUUID(string: "FFE2")

protocol PinIOModuleManagerDelegate: class {
    //func onPinIODidEndPinQuery(isDefaultConfigurationAssumed: Bool)
    func onPinIODidReceivePinState()
}

class PinData {
    enum Mode: UInt8 {
        case unknown = 255
        case input = 0          // Don't chage the values (these are the bytes defined by firmata spec)
        case output = 1
        
        case analog = 2
        case pwm = 3
        case servo = 4
    }
    
    enum DigitalValue: Int {
        case low = 0
        case high = 1
    }
    
    var digitalPinId: Int
    var analogPinId: Int = -1
    
    var isDigital: Bool
    var isAnalog: Bool
    var isPWM: Bool
    
    var mode = Mode.input
    var digitalValue =  DigitalValue.low
    var analogValue: Int = 0
    
    init(digitalPinId: Int, isDigital: Bool, isAnalog: Bool, isPWM: Bool) {
        self.digitalPinId = digitalPinId
        self.isDigital = isDigital
        self.isAnalog = isAnalog
        self.isPWM = isPWM
    }
}

struct TxCommand {
    let data: Data
    let peripheral: CBPeripheral
    let characteristic: CBCharacteristic
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
    
    private let SYSEX_START: UInt8 = 0xF0
    private let SYSEX_END: UInt8 = 0xF7
    
    var pins = [PinData]()
    
    var isFirstDidLoad = true
    var isFirstSend = true
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
    }
    
    private func updatePinsForReceivedStates(_ pinStates: Int, port: Int, footSwitch: Footswitch?) {
        let offset = 8 * port
        if offset > 0 { return }
        // Iterate through all pins
        if let footSwitch = footSwitch {
            var selectedId = -1
            for i in 0...7 {
                let mask = 1 << i
                let state = (pinStates & mask) >> i
                if let digitalId = digitalIDs[offset + i] {
                    if !footSwitch.buttons[digitalId].isOn && (state == 0) {
                        selectedId = digitalId
                    }
                }
                print("[\(i) - \(state)]\t")
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
            print("\n")
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
            
            print("receivedPinStateDataBuffer size: \(receivedPinStateDataBuffer.count)")
            
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
    
    private func digitalValueDescription(_ digitalValue: PinData.DigitalValue) -> String {
        
        
        var resultStringId: String
        switch digitalValue {
        case .low: resultStringId = "LOW"
        case .high: resultStringId = "HIGH"
        }
        
        return resultStringId
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
                centralManager.scanForPeripherals(withServices: [bricksCBUUID,footswitchesServiceCBUUID])
                
            }
        }
        
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print(error)
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print(peripheral)
        foundFootswitches.append(peripheral)
        centralManager.connect(foundFootswitches[0])
        
        let uuidArray = advertisementData[CBAdvertisementDataServiceUUIDsKey] as! [CBUUID]
        
        for uuid in uuidArray {
            if uuid == footswitchesServiceCBUUID {
                let newFootswitch = Footswitch(id: peripheral.identifier, name: peripheral.name ?? "Unnamed")
                newFootswitch.peripheral = peripheral
                if !UserDevicesManager.default.userFootswitches.contains(newFootswitch) {
                UserDevicesManager.default.userFootswitches.append(newFootswitch)
                    break
                }
            }
            if uuid == bricksCBUUID {
                let brick = Brick(id: peripheral.identifier)
                brick.peripheral = peripheral
                brick.deviceName = peripheral.name
                brick.updateConnection(isConnected: true)
                if !UserDevicesManager.default.userBricks.contains(brick) {
                    UserDevicesManager.default.userBricks.append(brick)
                }
                break
            }
        }
        
        if isFirstDidLoad {
            isFirstDidLoad = false
        }
        
        devicesTabViewController?.bricksCollectionView.reloadData()
        devicesTabViewController?.footswitchesCollectionView.reloadData()
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
        print("Connected!")
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Disconnected!")
        if let brick = UserDevicesManager.default.brickForPeripheral(peripheral: peripheral) {
            brick.updateConnection(isConnected: false)
        }
        
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
        let footswitch = UserDevicesManager.default.footswitchByPeripheral(peripheral: peripheral)
        let brick = UserDevicesManager.default.brickForPeripheral(peripheral: peripheral)
        for characteristic in characteristics {
            //print(characteristic)
            
            if characteristic.properties.contains(.write) {
                print("\(characteristic.uuid): properties contains .write")
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
                    print("\(characteristic.uuid): properties contains .notify")
                    peripheral.setNotifyValue(true, for: characteristic)
                    footswitch.rx = characteristic
                }
                //init footswitch ports if it's full connected
                if(footswitch.peripheral != nil && footswitch.rx != nil && footswitch.tx != nil) {
                    initFootSwitchPorts(footSwitch: footswitch)
                }
            }
        }
    }
    
    func initFootSwitchPorts(footSwitch: Footswitch) {
        guard let peripheral = footSwitch.peripheral, let tx = footSwitch.tx else {
            print("Can't send message");
            return;
        }
        let data0: UInt8 = 0xD0 + 0        // start port 0 digital reporting (0xD0 + port#)
        let data1: UInt8 = 1                  // enable
        var bytes: [UInt8] = [data0, data1]
        var data = Data(bytes: bytes)
        sendCommand(to: peripheral, characteristic: tx, data: data)
        for id in [2,3,5,6,9] {
            bytes = [0xf4, UInt8(id), 0]
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
//            print(characteristic.value ?? "no value")
        case footswitchRxCharacteristic:
            print(characteristic.value ?? "no value")
            guard let characteristicData = characteristic.value else { return }
            receivedPinState(data: characteristicData, footSwitch: UserDevicesManager.default.footswitchByPeripheral(peripheral: peripheral))
        default:
            print("Unhandled Characteristic UUID: \(characteristic.uuid)")
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        guard error == nil else {
            print("Error discovering services: error")
            return
        }
        print("Message sent")
        if(commandQueue.count > 0) {
            print("Queue count: \(commandQueue.count)\n")
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
