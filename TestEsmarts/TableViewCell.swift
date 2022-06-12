//
//  TableViewCell.swift
//  TestEsmarts
//
//  Created by Тоха on 11.06.2022.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    static let cellId = String(describing: TableViewCell.self)
    
    let nameLabel = UILabel()
    let percentLabel = UILabel()
    let manufactorLabel = UILabel()
    let modelLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureSubviews()
        layoutIt()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    private func configureSubviews() {
        contentView.backgroundColor = .gray
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textColor = .black
        nameLabel.font = .boldSystemFont(ofSize: 14)
        
        modelLabel.translatesAutoresizingMaskIntoConstraints = false
        modelLabel.textColor = .darkGray
        modelLabel.font = .boldSystemFont(ofSize: 10)
        
        manufactorLabel.translatesAutoresizingMaskIntoConstraints = false
        manufactorLabel.textColor = .darkGray
        manufactorLabel.font = .boldSystemFont(ofSize: 10)
        
        percentLabel.translatesAutoresizingMaskIntoConstraints = false
        percentLabel.textColor = .darkGray
        percentLabel.font = .systemFont(ofSize: 12)
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(percentLabel)
        contentView.addSubview(manufactorLabel)
        contentView.addSubview(modelLabel)
    }
    
    private func layoutIt() {
        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -4),
            nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            
            modelLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2),
            modelLabel.leftAnchor.constraint(equalTo: manufactorLabel.rightAnchor, constant: 5),
            
            manufactorLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2),
            manufactorLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            
            
            percentLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            percentLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
        ])
        
    }
    
    
    func configurateText(device: Device) {
        nameLabel.text = device.name
        manufactorLabel.text = device.manfactor
        modelLabel.text = device.model
        if let percent = device.battaryLavel {
            percentLabel.text = String(percent) + " %"
        } else {
            percentLabel.text = "No chargeble"
        }
    }
}
