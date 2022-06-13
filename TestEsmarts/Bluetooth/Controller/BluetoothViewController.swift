//
//  ViewController.swift
//  TestEsmarts
//
//  Created by Тоха on 10.06.2022.
//

import UIKit
import CoreBluetooth

struct Device {
    var name: String?
    var model: String?
    var manfactor: String?
    var battaryLavel: UInt8?
    var uuid: String?
}

protocol BaseController: AnyObject {
    var presenter: BasePresenter? { get set }
}

final class BluetoothViewController: UIViewController, PresenterOutput, BaseController {
    
    //MARK: - Prooerties
    var mainTableView = UITableView()
    var presenter: BasePresenter?
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
        mainTableView.register(BluetoothTableHeader.self, forHeaderFooterViewReuseIdentifier: BluetoothTableHeader.headerId)
        mainTableView.register(BluetoothTableViewCell.self, forCellReuseIdentifier: BluetoothTableViewCell.cellId)
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
    
    
    //MARK: - PresenterOutput
    func setNewData(_ data: [Device]) {
        self.devices = data
    }
    
}

//MARK: - Extensions
extension BluetoothViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BluetoothTableViewCell.cellId, for: indexPath) as? BluetoothTableViewCell else {
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
        if let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: BluetoothTableHeader.headerId) as? BluetoothTableHeader {
            return header
        }
        return UITableViewHeaderFooterView()
    }
}
