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
            // TODO: Алерт
            break
        case .poweredOn:
            startScan()
        @unknown default:
            debugPrint("\(managerState)| unknown CBManager state configuration")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        perirheral1 = peripheral
        perirheral1!.delegate = self
        percentsDict[peripheral.name ?? "Unknown"] = 0
//        devices.append(peripheral)
        mainTableView.reloadData()
        centralManager?.connect(perirheral1!, options: nil)
        
//        peripheral.discoverServices(nil)
        
        
    }
    
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("fuck")
        peripheral.discoverServices(nil)
        
    }
}

extension MainViewController: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        for service in peripheral.services ?? [] {
            print(CBUUID(string: "180F"))
            
            if service.uuid == CBUUID(string: "180F") {
                peripheral.discoverCharacteristics(nil, for: service)
                
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        for char in service.characteristics ?? [] {
             let uuid = CBUUID(string: "2A19") // Battery level
            
            if char.uuid == uuid {
                peripheral.readValue(for: char)
                print(char.uuid)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if characteristic.uuid == CBUUID(string: "2A19") && characteristic.value != nil {
            let value = characteristic.value
            let valueUInt8 = [UInt8](value!)
            print("\(valueUInt8)")
            print("\(valueUInt8[0])")
            let batteryLevel = Int32(bitPattern: UInt32(valueUInt8[0]))
            print(batteryLevel)
            percentsDict[peripheral.name ?? "Unknown"] = batteryLevel
            mainTableView.reloadData()
        }
    }
    }

