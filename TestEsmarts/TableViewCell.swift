//
//  TableViewCell.swift
//  TestEsmarts
//
//  Created by Тоха on 11.06.2022.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    static let cellId = String(describing: TableViewCell.self)
    
    let separator1 = UIView()
    let separator2 = UIView()
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
        backgroundColor = .clear
        contentView.clipsToBounds = true
        contentView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.25)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textColor = .black
        nameLabel.font = .boldSystemFont(ofSize: 14)
        
        modelLabel.translatesAutoresizingMaskIntoConstraints = false
        modelLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.4)
        modelLabel.font = .boldSystemFont(ofSize: 10)
        
        manufactorLabel.translatesAutoresizingMaskIntoConstraints = false
        manufactorLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.4)
        manufactorLabel.font = .boldSystemFont(ofSize: 10)
        
        percentLabel.translatesAutoresizingMaskIntoConstraints = false
        percentLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.7)
        percentLabel.font = .systemFont(ofSize: 12)
        
        separator1.translatesAutoresizingMaskIntoConstraints = false
        separator1.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.1)
        separator2.translatesAutoresizingMaskIntoConstraints = false
        separator2.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.1)
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(percentLabel)
        contentView.addSubview(manufactorLabel)
        contentView.addSubview(modelLabel)
        contentView.addSubview(separator1)
        contentView.addSubview(separator2)
    }
    
    private func layoutIt() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            
            modelLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            modelLabel.leftAnchor.constraint(equalTo: manufactorLabel.rightAnchor, constant: 5),
            
            manufactorLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            manufactorLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            
            
            percentLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            percentLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            
            separator1.topAnchor.constraint(equalTo: contentView.topAnchor),
            separator1.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            separator1.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            separator1.heightAnchor.constraint(equalToConstant: 1),
            
            separator2.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separator2.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            separator2.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            separator2.heightAnchor.constraint(equalToConstant: 1)
        ])
        
    }
    
    func makeCorners() {
        contentView.layer.cornerRadius = 16
        contentView.layer.maskedCorners = [ .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
    
    func disableCorners() {
        contentView.layer.cornerRadius = 0
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
