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
    var BTservice: BluetoothService = BluetoothServiceImpl()
    private var devices: [Device] = [] {
        didSet {
            mainTableView.reloadData()
        }
    }
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUps()
        setUpTableView()
        registerCells()
        BTservice.delegate = self
        BTservice.startScan()
        startingTimer()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setUpTableViewLayout()
        setUpConstrains()
    }
    
    //MARK: - Setups
    
    private func initialSetUps() {
        view.backgroundColor = .clear
        view.addSubview(mainTableView)
    }

    private func setUpTableView() {
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.showsVerticalScrollIndicator = false
        mainTableView.translatesAutoresizingMaskIntoConstraints = false
        
        mainTableView.sectionHeaderHeight = 70
        mainTableView.sectionHeaderTopPadding = 0
        
        mainTableView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3)
        mainTableView.rowHeight = 50
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
                mainTableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8),
                mainTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
                mainTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
            ]
        )
    }
    
    
    //MARK: - Actions
    private func startingTimer() {
        let _ = Timer.scheduledTimer(withTimeInterval: 300, repeats: true, block: { _ in self.restartAll() })
    }
    
    private func restartAll() {
        print("restarting")
        BTservice.restartAll()
        devices = []
        print("restarted")
    }
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
        if indexPath.row == devices.count-1 {
            cell.makeCorners()
        } else {
            cell.disableCorners()
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
