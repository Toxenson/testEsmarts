//
//  TableHeader.swift
//  TestEsmarts
//
//  Created by Тоха on 10.06.2022.
//

import UIKit

final class BluetoothTableHeader: UITableViewHeaderFooterView {
    
    static let headerId = String(describing: BluetoothTableHeader.self)
    private let label = UILabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
    
    private func configure() {
//        contentView.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Avialable"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        contentView.layer.cornerRadius = 16
        contentView.layer.maskedCorners = [ .layerMinXMinYCorner, .layerMaxXMinYCorner]
        contentView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25)
        contentView.addSubview(label)
    }
    
    
    private func layout() {
        NSLayoutConstraint.activate([
//
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
}
