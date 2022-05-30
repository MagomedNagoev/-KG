//
//  BalanceCell.swift
//  Курсы валют KG
//
//  Created by Нагоев Магомед on 05.04.2022.
//

import UIKit

class BalanceCell: UITableViewCell {
    static let identifier = "BalanceCell"
    public var presenter: BalancesPresenterProtocol!
    private var amount = 0

    private var index = IndexPath()
    private var valuteNameLabel: UILabel = {
        let label = UILabel()
        label.text = "kgs".uppercased()
        label.textColor = #colorLiteral(red: 0.8350862509, green: 0.8350862509, blue: 0.8350862509, alpha: 1)
        label.textAlignment = .left
        label.font = UIFont(name: "OpenSansRoman-SemiBold", size: 18)
        return label
    }()

    var amountTextField: CurrencyTextField = {
        let textField = CurrencyTextField()
        return textField
    }()

    private var countryImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "kgs")
        imageView.layer.cornerRadius = 40/2
        imageView.clipsToBounds = true
        imageView.backgroundColor = .orange
        return imageView
    }()
    
    private var line: UIView = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        amountTextField.delegate = self
//        amountTextField.addTarget(self, action: #selector(editRate), for: .editingChanged)
//
        
        contentView.isUserInteractionEnabled = false
        countryImage.translatesAutoresizingMaskIntoConstraints = false
        valuteNameLabel.translatesAutoresizingMaskIntoConstraints = false
        amountTextField.translatesAutoresizingMaskIntoConstraints = false
        amountTextField.translatesAutoresizingMaskIntoConstraints = false
        
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = #colorLiteral(red: 0.7729910436, green: 0.7729910436, blue: 0.7729910436, alpha: 1)
        line.alpha = 0.2
        
        addSubview(countryImage)
        
        NSLayoutConstraint.activate([
            countryImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            countryImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 0
            ),
            countryImage.heightAnchor.constraint(equalToConstant: 40),
            countryImage.widthAnchor.constraint(equalToConstant: 40)
        ])
        
        addSubview(valuteNameLabel)
        NSLayoutConstraint.activate([
            valuteNameLabel.centerYAnchor.constraint(equalTo: countryImage.centerYAnchor),
            valuteNameLabel.leftAnchor.constraint(equalTo: countryImage.rightAnchor, constant: 15),
            valuteNameLabel.rightAnchor.constraint(equalTo: centerXAnchor, constant: -10)
        ])
        
        addSubview(line)
        NSLayoutConstraint.activate([
            line.heightAnchor.constraint(equalToConstant: 0.5),
            line.rightAnchor.constraint(equalTo: rightAnchor, constant: 0),
            line.leftAnchor.constraint(equalTo: valuteNameLabel.leftAnchor,constant: 0),
            line.bottomAnchor.constraint(equalTo: bottomAnchor)
            
        ])
        
        addSubview(amountTextField)
        NSLayoutConstraint.activate([
            amountTextField.leftAnchor.constraint(equalTo: centerXAnchor, constant: 0),
            amountTextField.rightAnchor.constraint(equalTo: rightAnchor, constant: 0),
            amountTextField.centerYAnchor.constraint(equalTo: countryImage.centerYAnchor)
        ])

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setData(nameValute: String?, amount: String?, presenter: BalancesPresenterProtocol, index: IndexPath) {
        self.amount = Int(amount?.filter {$0 != "," && $0 != "." && $0 != " "} ?? "") ?? 0
        valuteNameLabel.text = nameValute?.uppercased()
        countryImage.image = UIImage(named: nameValute ?? "kgs")
        amountTextField.text = updateTextField()
        self.presenter = presenter
        self.index = index
    }

    @objc func editRate() {
        if let presenter = presenter {
        let rate = presenter.getRate(index: index)
            rate.amount = updateTextField()
            presenter.saveRate()
            presenter.view?.labelRefresh()
        }
    }
    
    func updateTextField() -> String? {
        let number = Double(amount / 100) + Double(amount % 100) / 100
        return Formatter.currency.string(from: NSNumber(value: number))
    }
}

extension BalanceCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let digit = Int(string) {
            if amount > 9_999_999_999 {
                return false
            }
            amount = amount * 10 + digit
            amountTextField.text = updateTextField()
        }
        
        if string == "" {
            amount = amount / 10
            amountTextField.text = updateTextField()
        }
        editRate()
        return false
    }
}
