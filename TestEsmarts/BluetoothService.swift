//
//  File.swift
//  TestEsmarts
//
//  Created by Тоха on 10.06.2022.
//

import CoreBluetooth
import UIKit

var perirheral1: CBPeripheral?

protocol MainViewControllerDelegate: AnyObject {
    func didCreatedDevice(device: Device)
}

protocol BluetoothService {
    var delegate: MainViewControllerDelegate? { get set }
    func startScan()
    func stopScan()
    func restartAll()
}

final class BluetoothServiceImpl: NSObject, CBCentralManagerDelegate, BluetoothService {
    
    //MARK: - Properties
    private var device: Device?
    private var devices: [Device] = []
    private var battery: UInt8?
    private var name: String = ""
    private var model: String?
    private var manufactor: String?
    private let centralManager: CBCentralManager = CBCentralManager()
    var delegate: MainViewControllerDelegate?
    
    
    
    //MARK: - Lifecycle
    
    override init() {
        super.init()
        centralManagerDidUpdateState(centralManager)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        processBLEState(central.state)
    }
    
    private func processBLEState(_ managerState: CBManagerState) {
        switch managerState {
        case .unknown,
             .resetting,
             .unsupported,
             .unauthorized,
             .poweredOff:
            break
        case .poweredOn:
            startScan()
        @unknown default:
            debugPrint("\(managerState)| unknown CBManager state configuration")
        }
    }
    
    func startScan() {
        centralManager.delegate = self
        centralManager.scanForPeripherals(withServices: nil)
    }
    
    func stopScan() {
        centralManager.stopScan()
    }
    
    func restartAll() {
        stopScan()
        device = nil
        devices = []
        battery = nil
        name = ""
        model = nil
        manufactor = nil
        startScan()
    }
    
    func configureDeviceWith() {
        device = Device(name: name, model: model, manfactor: manufactor, battaryLavel: battery)
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
//        print(peripheral)
        battery = nil
        name = ""
        model = nil
        manufactor = nil
        if peripheral.name != nil && !devices.contains(where: {device in device.name == peripheral.name}) {
            perirheral1 = peripheral
            stopScan()
            self.name = peripheral.name!
            perirheral1!.delegate = self
            centralManager.connect(perirheral1!)
            _ = Timer.scheduledTimer(withTimeInterval: 10, repeats: false, block: {_ in self.centralManager.cancelPeripheralConnection(peripheral)})
            print("найдено \(peripheral.name!)")
        }
        
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
            peripheral.discoverServices(nil)
        print("присоеденено \(peripheral.name!)")
        
    }
}

extension BluetoothServiceImpl: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        print("обработка \(peripheral.name!)")
        peripheral.services?.forEach{
            service in
            print(service)
        }
        guard let services = peripheral.services else {
            centralManager.cancelPeripheralConnection(peripheral)
            return
        }
        let batteryUUID = CBUUID(string: "180F")
        let deviceUUID = CBUUID(string: "180A")
        if !services.contains(where: {services in
            return services.uuid == batteryUUID || services.uuid == deviceUUID}) {
            centralManager.cancelPeripheralConnection(peripheral)
        }

        for service in services {
            print(service.uuid)
            if service.uuid == batteryUUID {
                peripheral.discoverCharacteristics(nil, for: service)
            }
            if service.uuid == deviceUUID {
                print("entering")
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }
        
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        if let manufactorCharacteristic = service.characteristics?.first(where: {$0.uuid == CBUUID(string: "2A29")}) {
            peripheral.readValue(for: manufactorCharacteristic)
        }
        if let modelCharacteristic = service.characteristics?.first(where: {$0.uuid == CBUUID(string: "2A24")}) {
            peripheral.readValue(for: modelCharacteristic)
        }
        if let batteryLevelCharacteristic = service.characteristics?.first(where: {$0.uuid == CBUUID(string: "2A19")}) {
            peripheral.readValue(for: batteryLevelCharacteristic)
        }
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        print("reading chars")
        guard let data = characteristic.value else {
            return
            }
        if characteristic.uuid == CBUUID(string: "2A19") {
            guard let firstByte = data.first else {
                return
            }
            let batteryLevel = firstByte
            self.battery = batteryLevel
            }
        if characteristic.uuid == CBUUID(string: "2A29") {
            let manufactor = String(decoding: data, as: UTF8.self)
            self.manufactor = manufactor
        }
        if characteristic.uuid == CBUUID(string: "2A24") {
            let model = String(decoding: data, as: UTF8.self)
            self.model = model
        }
        
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("не смог подключить \(peripheral.name!)")
        startScan()
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("отключен \(peripheral.name!)")
        configureDeviceWith()
        devices.append(device!)
        delegate?.didCreatedDevice(device: device!)
        startScan()
    }
}

