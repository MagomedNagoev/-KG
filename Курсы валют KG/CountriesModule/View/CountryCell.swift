//
//  CountrieCell.swift
//  Курсы валют KG
//
//  Created by Нагоев Магомед on 16.04.2022.
//

import UIKit

class CountryCell: UITableViewCell {
    static let identifier = "CountryCell"

    private var valuteNameLabel: UILabel = {
        let label = UILabel()
        label.text = "kgs".uppercased()
        label.textColor = #colorLiteral(red: 0.8350862509, green: 0.8350862509, blue: 0.8350862509, alpha: 1)
        label.textAlignment = .left
        label.font = UIFont(name: "OpenSansRoman-SemiBold", size: 18)
        return label
    }()

    private var valuteFullNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Киргизский сом"
        label.textColor = .lightGray
        label.textAlignment = .left
        label.font = UIFont(name: "OpenSans-Regular", size: 16)
        return label
    }()

    private var countryImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "kgs")
        imageView.layer.cornerRadius = 40/2
        imageView.clipsToBounds = true
        imageView.backgroundColor = .orange
        return imageView
    }()
    
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis  = NSLayoutConstraint.Axis.horizontal
        stackView.distribution  = UIStackView.Distribution.fill
        stackView.alignment = UIStackView.Alignment.center
        stackView.spacing   = 15
        return stackView
    }()
    
    private var line: UIView = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        
        stackView.addArrangedSubview(countryImage)
        stackView.addArrangedSubview(valuteNameLabel)
        stackView.addArrangedSubview(valuteFullNameLabel)
        
        
        contentView.isUserInteractionEnabled = false
        countryImage.translatesAutoresizingMaskIntoConstraints = false
        valuteNameLabel.translatesAutoresizingMaskIntoConstraints = false
        valuteFullNameLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = .white
        
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            stackView.leftAnchor.constraint(equalTo: leftAnchor,constant: 20),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -0.5)
        ])
        
        addSubview(line)
        NSLayoutConstraint.activate([
            line.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 0),
            line.rightAnchor.constraint(equalTo: stackView.rightAnchor, constant: 0),
            line.leftAnchor.constraint(equalTo: valuteNameLabel.leftAnchor,constant: 0),
            line.bottomAnchor.constraint(equalTo: bottomAnchor)

        ])
        
        stackView.addSubview(countryImage)
        NSLayoutConstraint.activate([
            countryImage.heightAnchor.constraint(equalToConstant: 40),
            countryImage.widthAnchor.constraint(equalToConstant: 40)
        ])
        

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setData(nameValute: String?, fullNameValute: String?) {
        valuteNameLabel.text = nameValute?.uppercased()
        valuteFullNameLabel.text = fullNameValute
        countryImage.image = UIImage(named: nameValute ?? "kgs")
    }


}


