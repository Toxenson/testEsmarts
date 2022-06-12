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
    let name: String
    let model: String?
    let manfactor: String?
    let battaryLavel: UInt8?
}

class MainViewController: UIViewController {
    

    
    //MARK: - Prooerties
    var mainTableView = UITableView()
    var BTservice = BluetoothServiceImpl()
    let button = UIButton()
    private var numOFDevices = 0
    private var devices: [Device] = [] {
        didSet {
            numOFDevices = devices.count
            mainTableView.reloadData()
        }
    }
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUps()
        setUpTableView()
        registerCells()
        BTservice.mainController = self
        BTservice.startScan()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setUpTableViewLayout()
        setUpConstrains()
    }
    
    //MARK: - Setups
    
    private func initialSetUps() {
        view.backgroundColor = .white
        view.addSubview(mainTableView)
        view.addSubview(button)
    }

    private func setUpTableView() {
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.showsVerticalScrollIndicator = false
        mainTableView.translatesAutoresizingMaskIntoConstraints = false
        
        mainTableView.sectionHeaderHeight = 70
        mainTableView.sectionHeaderTopPadding = 0
        
        mainTableView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
    }
    
    private func registerCells() {
        mainTableView.register(TableHeader.self, forHeaderFooterViewReuseIdentifier: TableHeader.headerId)
        mainTableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.cellId)
    }

    
    
    //MARK: - Layout
    
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
    
    
    //MARK: - Actions
    
}

//MARK: - Extensions

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.cellId, for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        let device = devices[indexPath.row]
        cell.configurateText(device: device)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TableHeader.headerId) as? TableHeader {
            return header
        }
        return UITableViewHeaderFooterView()
    }
}

extension MainViewController: MainViewControllerDelegate {
    func didCreatedDevice(device: Device) {
        devices.append(device)
    }
}
