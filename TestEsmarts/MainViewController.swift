//
//  ViewController.swift
//  TestEsmarts
//
//  Created by Тоха on 10.06.2022.
//

import UIKit
import CoreBluetooth

// TODO: скруглить ячейку снизу
struct Device {
    let icon: UIImage
    let name: String
    let signal: Signal
    
    
    enum Signal {
        case none
        case small
        case middle
        case strong
    }
}

class MainViewController: UIViewController {

    let mainTableView = UITableView()
    let dispatchGroup = DispatchGroup()
    var centralManager: CBCentralManager?
    var devices: [CBPeripheral] = []
    var peripheral: CBPeripheral?
    var percentsDict: [String:Int32] = [:] {
        didSet {
            mainTableView.reloadData()
//            print(percentsDict)
        }
    }
    private var service: CBService?
    
//    var devices = [CBPeripheral]() { // [UUID: Device] for unique devices
//        didSet {
//            mainTableView.reloadData()
//        }
//    }
    var cbperipheral: CBPeripheral?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUps()
        setUpTableView()
        registerCells()
        setUpCentralManager()
        handleCBDevices()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setUpTableViewLayout()
        setUpConstrains()
    }
    
    private func initialSetUps() {
        view.backgroundColor = .white
        view.addSubview(mainTableView)
    }

    private func setUpTableView() {
        mainTableView.delegate = self
        mainTableView.dataSource = self
        
        mainTableView.showsVerticalScrollIndicator = false
        
        mainTableView.translatesAutoresizingMaskIntoConstraints = false
        
        mainTableView.sectionHeaderHeight = 70
        mainTableView.sectionHeaderTopPadding = 0
        
        mainTableView.backgroundColor = .clear
    }
    
    private func registerCells() {
        mainTableView.register(TableHeader.self, forHeaderFooterViewReuseIdentifier: TableHeader.headerId)
        mainTableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.cellId)
    }
    
    private func setUpCentralManager() {
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
        centralManager?.delegate = self
    }
    
    func startScan() {
        let batteruID = CBUUID(string: "180F")
        centralManager?.scanForPeripherals(withServices: nil, options: nil)
    }
    
    func stopScan() {
        centralManager?.stopScan()
    }
    
    func handleCBDevices() {
        let t1 = Timer(timeInterval: 300, repeats: true) {
            timer in
            print("restarted")
            self.mainTableView.beginUpdates()
            self.stopScan()
            self.percentsDict = [:]
            self.mainTableView.endUpdates()
            self.startScan()
        }
    }
    
    
    func handleCBDevicesUpdateName(_ device: CBPeripheral) {
        mainTableView.reloadData()
    }
    
    private func setUpTableViewLayout() {
        mainTableView.layer.cornerRadius = 16
    }
    
    private func setUpConstrains() {
        NSLayoutConstraint.activate(
            [
                mainTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                mainTableView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                mainTableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
                mainTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
                mainTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
            ]
        )
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        percentsDict.keys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.cellId, for: indexPath) as? TableViewCell else {return UITableViewCell()}
        let key = Array(percentsDict.keys)[indexPath.row]
        cell.configuteText(name: key, percent: percentsDict[key] ?? 0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TableHeader.headerId) as? TableHeader {
            return header
        }
        return UITableViewHeaderFooterView()
    }
}

