//
//  Presenter.swift
//  TestEsmarts
//
//  Created by Тоха on 13.06.2022.
//

import Foundation
import CoreBluetooth

protocol BasePresenter: AnyObject {
}

protocol PresenterOutput: AnyObject {
    func setNewData(_ data: [Device])
}

final class BluetoothPresenter: BasePresenter  {
    
    private var btService: BluetoothService = BluetoothServiceImpl()
    private var timer: Timer?
    private var devices: [Device] = [] {
        didSet {
            output?.setNewData(devices)
        }
    }
    weak var output: PresenterOutput?
    
    init() {
        setupTimer()
        btService.startScan()
        btService.onDeviceGet = { [weak self] device in
            self?.devices.append(device)
        }
    }
    
    private func setupTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 300, repeats: true, block: { [weak self] _ in
            self?.btService.restartAll()
            self?.devices = []
        })
    }
}
