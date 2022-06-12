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

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutIt()
    }
    
    private func configureSubviews() {
        contentView.backgroundColor = .gray
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textColor = .black
        nameLabel.font = .boldSystemFont(ofSize: 14)
        
        percentLabel.translatesAutoresizingMaskIntoConstraints = false
        percentLabel.textColor = .darkGray
        percentLabel.font = .systemFont(ofSize: 12)
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(percentLabel)

    }
    
    private func layoutIt() {
        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            
            
            percentLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            percentLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
        ])
        
    }
    
    func configuteText(name: String, percent: String) {
//        print(name)
        nameLabel.text = name
        if percent == "" {
            percentLabel.text = "No info"
        } else  {
            percentLabel.text = String(percent)
        }
        
    }
}
