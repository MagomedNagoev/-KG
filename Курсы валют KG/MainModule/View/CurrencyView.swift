//
//  ConverterView.swift
//  Курсы валют KG
//
//  Created by Нагоев Магомед on 20.03.2022.
//

import UIKit

class CurrencyView: UIView {
    let picker = UIPickerView()
    var amount = 0
    var countryRow: Int = 0 {
        willSet(newValue) {
            setData2(indexCountry: newValue)
        }
        didSet {
            presenter.view?.calculateSums(numberCountry: numberCountry)
        }
    }
    var numberCountry = ""
    public var presenter: MainPresenterProtocol!
    
    private var button = UIButton()

    private var countryImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 45/2
        imageView.clipsToBounds = true
        imageView.backgroundColor = .orange
        return imageView
    }()
    
     var valuteNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    var typeLabel: UILabel = {
       let label = UILabel()
       label.textColor = .lightGray
       label.textAlignment = .left
       label.font = UIFont.boldSystemFont(ofSize: 14)
       return label
   }()
    
    private var valuteFullNameTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .lightGray
        textField.tintColor = .clear
        textField.textAlignment = .left
        textField.font = UIFont.systemFont(ofSize: 15)


        return textField
    }()
    
    var sumTextField: CurrencyTextField = {
        let textField = CurrencyTextField()
        textField.text = ""
        return textField
    }()
    
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis  = NSLayoutConstraint.Axis.vertical
        stackView.distribution  = UIStackView.Distribution.equalSpacing
        stackView.alignment = UIStackView.Alignment.leading
        stackView.spacing   = 5
        return stackView
    }()
    
    convenience init(valuteName: String, valuteFullname: String, numberCountry: String, countryRow: Int) {
        self.init()
        valuteNameLabel.text = valuteName.uppercased()
        valuteFullNameTextField.text = valuteFullname
        countryImage.image = UIImage(named: valuteName)
        self.numberCountry = numberCountry
        self.countryRow = countryRow
        
        if numberCountry == "First" {
            typeLabel.text = "Я получу"
        } else {
            typeLabel.text = "У меня есть"
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewConfig()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func viewConfig() {
        sumTextField.delegate = self
        picker.isHidden = false
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        picker.delegate = self
        valuteFullNameTextField.inputView = picker
        
        stackView.addArrangedSubview(valuteNameLabel)
        stackView.addArrangedSubview(valuteFullNameTextField)
        
        countryImage.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        sumTextField.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(typeLabel)
        NSLayoutConstraint.activate([
            typeLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            typeLabel.bottomAnchor.constraint(equalTo: topAnchor, constant: 15),
            typeLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 0),
            typeLabel.rightAnchor.constraint(equalTo: rightAnchor)
        ])
        
        addSubview(countryImage)
        NSLayoutConstraint.activate([
            countryImage.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 5),
            countryImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 0),
            countryImage.heightAnchor.constraint(equalToConstant: 45),
            countryImage.widthAnchor.constraint(equalToConstant: 45)
        ])
        

        
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: countryImage.centerYAnchor),
            stackView.leftAnchor.constraint(equalTo: countryImage.rightAnchor, constant: 5),
            stackView.rightAnchor.constraint(equalTo: centerXAnchor, constant: 30),
        ])
        
        addSubview(sumTextField)
        NSLayoutConstraint.activate([
            sumTextField.topAnchor.constraint(equalTo: topAnchor),
            sumTextField.bottomAnchor.constraint(equalTo: countryImage.bottomAnchor),
            sumTextField.leftAnchor.constraint(equalTo: stackView.rightAnchor, constant: 0),
            sumTextField.rightAnchor.constraint(equalTo: rightAnchor, constant: 0),
        ])
        
        addSubview(button)
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: topAnchor),
            button.bottomAnchor.constraint(equalTo: countryImage.bottomAnchor),
            button.leftAnchor.constraint(equalTo: leftAnchor),
            button.rightAnchor.constraint(equalTo: sumTextField.leftAnchor)
        ])
    }
    
    func setData2 (indexCountry: Int) {
        guard let valutes = presenter?.valutes else {
            return
        }
        let valute = valutes [indexCountry]
        if let titleAlias = valute.titleAlias {
            valuteNameLabel.text = titleAlias.uppercased()
            valuteFullNameTextField.text = valute.title
            countryImage.image = UIImage(named: titleAlias)
//            countryRow = indexCountry
        }
    }
    
    func setPresenter (presenter: MainPresenterProtocol) {
        self.presenter = presenter
        
    }
    
    @objc
    private func buttonPressed() {
        valuteFullNameTextField.becomeFirstResponder()
    }
    
    func blockedTF() {
        valuteFullNameTextField.isEnabled = false
    }
    
}

extension CurrencyView: UITextFieldDelegate {

    func updateTextField() -> String? {
        let number = Double(amount / 100) + Double(amount % 100) / 100
        return Formatter.currency.string(from: NSNumber(value: number))
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let digit = Int(string) {
            amount = amount * 10 + digit
            sumTextField.text = updateTextField()
        }
        
        if string == "" {
            amount = amount / 10
            sumTextField.text = updateTextField()
        }
        presenter.view?.calculateSums(numberCountry: numberCountry)
        return false
    }
}

// MARK: - Picker view data source
extension CurrencyView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let valutes = presenter?.valutes else {
            return 1
        }
        return valutes.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let valutes = presenter?.valutes else {
            return ""
        }
        
        let valute = valutes[row]
        return valute.title
    }
    
    func pickerView(_ pickerView: UIPickerView,
                didSelectRow row: Int,
                inComponent component: Int) {
        countryRow = row
    }

}
