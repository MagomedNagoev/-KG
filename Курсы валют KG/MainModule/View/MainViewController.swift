//
//  ViewController.swift
//  Курсы валют KG
//
//  Created by Нагоев Магомед on 18.03.2022.
//

import UIKit

class MainViewController: UIViewController {
    var presenter: MainPresenterProtocol!
    var tableView = UITableView()
    var isBuy = true
    private var buyLabel: UILabel = {
        let label = UILabel()
        label.text = "покупка"
        label.textColor = .lightGray
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Купить", "Продать"])
        control.selectedSegmentIndex = 0
        control.addTarget(self, action: #selector(changeIndex), for: .valueChanged)

        return control
    }()
    
    @objc
    func changeIndex() {
        if segmentedControl.selectedSegmentIndex == 0 {
            isBuy = true
            kgsCurrencyView.sumTextField.text = presenter.calculate(amountString: listCurrencyView.sumTextField.text ?? "0.00", fromCountry: listCurrencyView.countryRow, toCountry: kgsCurrencyView.countryRow, isBuy: isBuy, viewCountry: "First")
            kgsCurrencyView.amount = 0
        } else {
            isBuy = false
            print(isBuy)
            kgsCurrencyView.sumTextField.text = presenter.calculate(amountString: listCurrencyView.sumTextField.text ?? "0.00", fromCountry: listCurrencyView.countryRow, toCountry: kgsCurrencyView.countryRow, isBuy: isBuy, viewCountry: "First")
            kgsCurrencyView.amount = 0
        }
    }
    
    private var listCurrencyView = CurrencyView(valuteName: "usd", valuteFullname: "Американский доллар", numberCountry: "Second", countryRow: 1)
    private var kgsCurrencyView = CurrencyView(valuteName: "kgs", valuteFullname: "Киргизский сом", numberCountry: "First", countryRow: 0)
    
    private var sellLabel: UILabel = {
        let label = UILabel()
        label.text = "продажа"
        label.textColor = .lightGray
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIconfig()
        view.backgroundColor = UIColor(red: 52/255,
                                       green: 52/255,
                                       blue: 52/255,
                                       alpha: 1)
        
        
        hideKeyboardOnTap()
    }

    func UIconfig() {
        
        self.navigationController?.navigationBar.isHidden = true
        
        tableView.register(RateCell.self, forCellReuseIdentifier: RateCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = true
        tableView.separatorStyle = .none
        
        
        listCurrencyView.setPresenter(presenter: presenter)
        kgsCurrencyView.setPresenter(presenter: presenter)
//        listCurrencyView.picker.delegate = self
//        listCurrencyView.picker.dataSource = self
//        kgsCurrencyView.picker.delegate = self
//        kgsCurrencyView.picker.dataSource = self
//        kgsCurrencyView.blockedTF()

        
        
        let stackView = UIStackView()
        stackView.axis  = NSLayoutConstraint.Axis.horizontal
        stackView.distribution  = UIStackView.Distribution.equalSpacing
        stackView.alignment = UIStackView.Alignment.bottom
        stackView.spacing   = 16.0
        
        stackView.addArrangedSubview(buyLabel)
        stackView.addArrangedSubview(sellLabel)
        
        let converterStackView = UIStackView()
        converterStackView.backgroundColor = UIColor(red: 62/255,
                                       green: 62/255,
                                       blue: 63/255,
                                       alpha: 1)
        converterStackView.axis  = NSLayoutConstraint.Axis.vertical
        converterStackView.distribution  = UIStackView.Distribution.fillProportionally
        converterStackView.alignment = UIStackView.Alignment.fill
        converterStackView.spacing   = 5
        converterStackView.layer.cornerRadius = 15
        
        converterStackView.addArrangedSubview(listCurrencyView)
        converterStackView.addArrangedSubview(kgsCurrencyView)
        
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        sellLabel.translatesAutoresizingMaskIntoConstraints = false
        converterStackView.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(segmentedControl)
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo:
                                                        view.safeAreaLayoutGuide.topAnchor, constant: 70),
            segmentedControl.bottomAnchor.constraint(equalTo:
                                                        view.safeAreaLayoutGuide.topAnchor, constant: 100),
            segmentedControl.rightAnchor.constraint(equalTo:
                                                        view.rightAnchor, constant: -15),
            segmentedControl.leftAnchor.constraint(equalTo:
                                                        view.leftAnchor, constant: 15)
        ])

        
        view.addSubview(converterStackView)
        NSLayoutConstraint.activate([
            converterStackView.topAnchor.constraint(equalTo:
                                                        segmentedControl.bottomAnchor, constant: 20),
            converterStackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.18),
            converterStackView.rightAnchor.constraint(equalTo:
                                                        view.rightAnchor, constant: -15),
            converterStackView.leftAnchor.constraint(equalTo:
                                                        view.leftAnchor, constant: 15)
        ])
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25),
            stackView.leftAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            stackView.topAnchor.constraint(equalTo: converterStackView.bottomAnchor, constant: 0),
            stackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.04)
        ])
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25)
        ])

    }
    @objc func calculateKgsRate() {
        let currency = listCurrencyView.valuteNameLabel.text?.lowercased() ?? "usd"
        kgsCurrencyView.sumTextField.text = presenter.convertIntSum(amountString: listCurrencyView.sumTextField.text ?? "", currency: currency, selectedSegmentIndex: segmentedControl.selectedSegmentIndex)
        
    }
    
//    @objc func calculateIntRate() {
////        let currency = listCurrencyView.valuteNameLabel.text?.lowercased() ?? "usd"
////        listCurrencyView.sumTextField.text = presenter.convertKgsSum(amountString: kgsCurrencyView.sumTextField.text ?? "", currency: currency, selectedSegmentIndex: segmentedControl.selectedSegmentIndex)
//        guard let currency1 = listCurrencyView.valuteNameLabel.text?.lowercased(),
//              let currency2 = kgsCurrencyView.valuteNameLabel.text?.lowercased() else {
//            return
//        }
//        listCurrencyView.sumTextField.text = presenter.calculate(amountString: kgsCurrencyView.sumTextField.text ?? "", fromCountry: currency2, toCountry: currency1)
//    }
//    
//    @objc func calculateRate() {
//        guard let currency1 = listCurrencyView.valuteNameLabel.text?.lowercased(),
//              let currency2 = kgsCurrencyView.valuteNameLabel.text?.lowercased() else {
//            return
//        }
//        listCurrencyView.sumTextField.text = presenter.calculate(amountString: kgsCurrencyView.sumTextField.text ?? "", fromCountry: currency2, toCountry: currency1)
//    }
    
    func hideKeyboardOnTap()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(self.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
// MARK: - Table view data source
extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let valutes = presenter.getRatesWoKgs() else {
            return tableView.frame.height/6
        }
        return tableView.frame.height/CGFloat(valutes.count)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard let valutes = presenter.getRatesWoKgs() else {
            return 6
        }
        return valutes.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RateCell.identifier, for: indexPath) as? RateCell else {
            return UITableViewCell()
        }
        
        let rate = presenter.getRatesWoKgs()?[indexPath.row]
        cell.setData(nameValute: rate?.titleAlias,
                        sellRate: rate?.rates?.sellRate,
                        buyRate: rate?.rates?.buyRate)
        
        return cell
    }
}

extension MainViewController: MainViewProtocol {
    func calculateSums(countryRow: Int) {
        if countryRow == 1 {
            listCurrencyView.sumTextField.text = presenter.calculate(amountString: kgsCurrencyView.sumTextField.text ?? "0.00", fromCountry: kgsCurrencyView.countryRow, toCountry: listCurrencyView.countryRow, isBuy: isBuy, viewCountry: "Second")
            listCurrencyView.amount = 0
            print(isBuy)
        } else {
            kgsCurrencyView.sumTextField.text = presenter.calculate(amountString: listCurrencyView.sumTextField.text ?? "0.00", fromCountry: listCurrencyView.countryRow, toCountry: kgsCurrencyView.countryRow, isBuy: isBuy, viewCountry: "First")
            kgsCurrencyView.amount = 0
            print(isBuy)
        }
    }
    
    func success() {
            self.tableView.reloadData()
//        self.converter1View.setData(valutes: presenter.valutes)
       
    }
    
    func failure(error: Error) {
        print(error)
    }
}

//// MARK: - Picker view data source
//extension MainViewController: UIPickerViewDelegate, UIPickerViewDataSource {
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        1
//    }
//    
//    
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        guard let valutes = presenter.valutes else {
//            return 1
//        }
//        return valutes.count
//    }
//
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        guard let valutes = presenter.valutes else {
//            return "Американский доллар"
//        }
//        
//        let valute = valutes[row]
//
//        
//        if let valuteName = valute.titleAlias, let valuteFullName = valute.title {
//            listCurrencyView.setData(valuteName: valuteName, valuteFullName: valuteFullName)
//        }
//        calculateIntRate()
//        return valute.title
//    }
//    
//    func pickerView(_ pickerView: UIPickerView,
//                didSelectRow row: Int,
//                inComponent component: Int) {
//        
//    }
//
//}

//extension MainViewController: UITextFieldDelegate {
//    func updateTextField() -> String? {
//        let number = Double(amount / 100) + Double(amount % 100) / 100
//        return Formatter.currency.string(from: NSNumber(value: number))
//    }
//
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if let digit = Int(string) {
//            amount = amount * 10 + digit
//            amountTextField.text = updateTextField()
//        }
//
//        if string == "" {
//            amount = amount / 10
//            amountTextField.text = updateTextField()
//        }
//        editRate()
//        return false
//    }
//}
