//
//  File.swift
//  Birthday Notes
//
//  Created by mac on 06.10.2021.
//

import UIKit
import RealmSwift

class BirthdayTableViewCell: UITableViewCell {
    static let identifier = "BirthdayTableViewCell"
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 19)
        label.backgroundColor = .systemBackground
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        return label
    }()
    
    private lazy var surnameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 19)
        label.backgroundColor = .systemBackground
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Arial", size: 17)
        label.backgroundColor = .clear
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(nameLabel)
        contentView.addSubview(surnameLabel)
        contentView.addSubview(dateLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            nameLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 200),
            nameLabel.heightAnchor.constraint(equalToConstant: 35)
        ])
        
        NSLayoutConstraint.activate([
            surnameLabel.leftAnchor.constraint(equalTo: nameLabel.rightAnchor, constant: 5),
            surnameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            surnameLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 200),
            surnameLabel.heightAnchor.constraint(equalToConstant: 35)
        ])
        
        NSLayoutConstraint.activate([
            dateLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            dateLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 300),
            dateLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    func fill(item: BirthdayCellViewModel) {
        nameLabel.text = item.name
        surnameLabel.text = item.surname
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d MMMM, yyyy HH:mm"
        formatter.locale = NSLocale(localeIdentifier: "en_US") as Locale?
        let birthdayDateFormatter = formatter.string(from: item.birthdayDate as Date)
        dateLabel.text = birthdayDateFormatter
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
