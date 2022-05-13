//
//  RateCell.swift
//  Курсы валют KG
//
//  Created by Нагоев Магомед on 18.03.2022.
//

import UIKit

class RateCell: UITableViewCell {
    static let identifier = "RateCell"

    private var valuteNameLabel: UILabel = {
        let label = UILabel()
        label.text = "kgs".uppercased()
        label.textColor = .lightGray
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()

    private var sellRateLabel: UILabel = {
        let label = UILabel()
        label.text = "0.00"
        label.textColor = .lightGray
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private var buyRateLabel: UILabel = {
        let label = UILabel()
        label.text = "0.00"
        label.textColor = .lightGray
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()

    private var countryImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "kgs")
        imageView.layer.cornerRadius = 45/2
        imageView.clipsToBounds = true
        imageView.backgroundColor = .orange
        return imageView
    }()
    
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis  = NSLayoutConstraint.Axis.horizontal
        stackView.distribution  = UIStackView.Distribution.equalSpacing
        stackView.alignment = UIStackView.Alignment.center
        stackView.spacing   = 16.0
        return stackView
    }()
    
    private var line: UIView = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        

        
        contentView.isUserInteractionEnabled = false
        countryImage.translatesAutoresizingMaskIntoConstraints = false
        valuteNameLabel.translatesAutoresizingMaskIntoConstraints = false
        sellRateLabel.translatesAutoresizingMaskIntoConstraints = false
        buyRateLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = .white
        

        stackView.addArrangedSubview(buyRateLabel)
        stackView.addArrangedSubview(sellRateLabel)
        
        
        addSubview(countryImage)
        
        NSLayoutConstraint.activate([
            countryImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            countryImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 0
            ),
            countryImage.heightAnchor.constraint(equalToConstant: 45),
            countryImage.widthAnchor.constraint(equalToConstant: 45)
        ])
        
        addSubview(valuteNameLabel)
        NSLayoutConstraint.activate([
            valuteNameLabel.centerYAnchor.constraint(equalTo: countryImage.centerYAnchor),
            valuteNameLabel.leftAnchor.constraint(equalTo: countryImage.rightAnchor, constant: 5),
            valuteNameLabel.rightAnchor.constraint(equalTo: centerXAnchor, constant: -10)
        ])
        
        addSubview(line)
        NSLayoutConstraint.activate([
            line.heightAnchor.constraint(equalToConstant: 0.5),
            line.rightAnchor.constraint(equalTo: rightAnchor, constant: 0),
            line.leftAnchor.constraint(equalTo: valuteNameLabel.leftAnchor,constant: 0),
            line.bottomAnchor.constraint(equalTo: bottomAnchor)
            
        ])
        
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalTo: centerXAnchor, constant: 0),
            stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0),
            stackView.centerYAnchor.constraint(equalTo: countryImage.centerYAnchor)
        ])

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setData(nameValute: String?, sellRate: String?, buyRate: String?) {
        valuteNameLabel.text = nameValute?.uppercased()
        sellRateLabel.text = sellRate
        buyRateLabel.text = buyRate
        countryImage.image = UIImage(named: nameValute ?? "kgs")
    }


}

