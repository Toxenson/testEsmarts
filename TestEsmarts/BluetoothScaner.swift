//
//  File.swift
//  TestEsmarts
//
//  Created by Тоха on 10.06.2022.
//

import CoreBluetooth
import UIKit

var perirheral1: CBPeripheral?

extension MainViewController: CBCentralManagerDelegate {

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        processBLEState(central.state)
        debugPrint(central.state)
    }
    
    private func processBLEState(_ managerState: CBManagerState) {
        switch managerState {
        case .unknown,
             .resetting,
             .unsupported,
             .unauthorized,
             .poweredOff:
            stopScan()
            break
        case .poweredOn:
            startScan()
        @unknown default:
            debugPrint("\(managerState)| unknown CBManager state configuration")
        }
    }
    
    
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        if peripheral.name == nil {
            stopScan()
            startScan()
        } else {
            perirheral1 = peripheral
            centralManager?.stopScan()
            perirheral1!.delegate = self
            devices.append(perirheral1)
            percentsDict[peripheral.name ?? "Unknown"] = ""
            centralManager?.connect(perirheral1!, options: nil)
            let timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: false, block: {_ in self.centralManager?.cancelPeripheralConnection(peripheral)})
            print("найдено \(peripheral.name!)")
        }
        
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
//        print("connected to \(peripheral.name)")
            peripheral.discoverServices(nil)
        print("присоеденено \(peripheral.name!)")
        
    }
}

extension MainViewController: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        print("обработка \(peripheral.name!)")
        peripheral.services?.forEach{
            service in
            print(service)
        }
        guard let services = peripheral.services else {
            centralManager?.cancelPeripheralConnection(peripheral)
            return
        }
        let batteryUUID = CBUUID(string: "180F")
        let deviceUUID = CBUUID(string: "180A")
        if !services.contains(where: {services in
            return services.uuid == batteryUUID || services.uuid == deviceUUID}) {
            centralManager?.cancelPeripheralConnection(peripheral)
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
        print(service.characteristics)
        
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
            percentsDict[peripheral.name!] = String(batteryLevel) + " %" + " " + (percentsDict[peripheral.name!] ?? "")
            print("battery level:", batteryLevel)
            }
        if characteristic.uuid == CBUUID(string: "2A29") {
            let manufactor = String(decoding: data, as: UTF8.self)
            print(manufactor)
            percentsDict[peripheral.name!] = manufactor + " " + (percentsDict[peripheral.name!] ?? "")
        }
        if characteristic.uuid == CBUUID(string: "2A24") {
            let model = String(decoding: data, as: UTF8.self)
            print(model)
            percentsDict[peripheral.name!] = model + " " + (percentsDict[peripheral.name!] ?? "")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("не смог подключить \(peripheral.name!)")
        startScan()
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("отключен \(peripheral.name!)")
        startScan()
    }
}

