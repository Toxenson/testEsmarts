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

class MainViewController: UIViewController, MainViewControllerDelegate {
    func didCreatedDevice(dev: [Device]) {
        devices.append(dev.last!)
    }

    
    //MARK: - Prooerties
    var mainTableView = UITableView()
    var BTservice: BluetoothService  = BluetoothServiceImpl()
    let button = UIButton()
    private var numOFDevices = 0
    var devices: [Device] = [] {
        didSet {
            print(devices)
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
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(addDevice), for: .touchUpInside)
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
                mainTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
                
                button.topAnchor.constraint(equalTo: mainTableView.bottomAnchor, constant: 20),
                button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                button.heightAnchor.constraint(equalToConstant: 50),
                button.widthAnchor.constraint(equalToConstant: 100)
            ]
        )
    }
    
    
    //MARK: - Actions
    
    @objc func addDevice() {
        devices.append(Device(name: "sfds", model: "sdfdssds", manfactor: nil, battaryLavel: 3))
    }
}

//MARK: - Extensions

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.cellId, for: indexPath) as? TableViewCell else {
            print("cell not adding")
            return UITableViewCell()
        }
        print("cell adding")
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
