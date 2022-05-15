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
    private var buyLabel: UILabel = {
        let label = UILabel()
        label.text = "Покупка"
        label.textColor = .lightGray
        label.textAlignment = .left
        label.font = UIFont(name: "OpenSans-Regular", size: 15)
        return label
    }()
    
    private var sellLabel: UILabel = {
        let label = UILabel()
        label.text = "Продажа"
        label.textColor = .lightGray
        label.textAlignment = .left
        label.font = UIFont(name: "OpenSans-Regular", size: 15)
        return label
    }()
    
    private var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.9593981032, green: 0.9593981032, blue: 0.9593981032, alpha: 1)
        label.textAlignment = .left
        label.font = UIFont(name: "OpenSans-Regular", size: 15)
        return label
    }()
    
    private var greyView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 62/255,
                                       green: 62/255,
                                       blue: 63/255,
                                       alpha: 1)
        view.layer.cornerRadius = 8
        return view
    }()
    
    private var swipeButton: UIButton = {
      let button = UIButton()
        button.addTarget(self, action: #selector(swipeCurrency), for: .touchUpInside)
        
        let configuration = UIImage.SymbolConfiguration(pointSize: 14, weight: .light, scale: .large)
        let image = UIImage(systemName: "arrow.up.arrow.down", withConfiguration: configuration)?.withTintColor(#colorLiteral(red: 0.8476145864, green: 0.8476145864, blue: 0.8476145864, alpha: 1), renderingMode: .alwaysOriginal)
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.widthAnchor.constraint(equalToConstant: 55).isActive = true
        return button
    }()
    
    
    private var secondCurrencyView = CurrencyView(valuteName: "usd", valuteFullname: "Американский доллар", numberCountry: "Second", countryRow: 1)
    private var firstCurrencyView = CurrencyView(valuteName: "kgs", valuteFullname: "Киргизский сом", numberCountry: "First", countryRow: 0)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIconfig()
        view.backgroundColor = UIColor(red: 52/255,
                                       green: 52/255,
                                       blue: 52/255,
                                       alpha: 1)
        for family in UIFont.familyNames.sorted() {
            let names = UIFont.fontNames(forFamilyName: family)
            print("Family: \(family) Font names: \(names)")
        }
        hideKeyboardOnTap()
    }
    
    @objc
    func swipeCurrency() {
        (firstCurrencyView.countryRow,
         secondCurrencyView.countryRow) = (secondCurrencyView.countryRow,
                                           firstCurrencyView.countryRow)
    }

    // MARK: - Constraints
    func UIconfig() {
        
        self.navigationController?.navigationBar.isHidden = true
        
        tableView.register(RateCell.self, forCellReuseIdentifier: RateCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = true
        tableView.separatorStyle = .none
        
        
        secondCurrencyView.setPresenter(presenter: presenter)
        firstCurrencyView.setPresenter(presenter: presenter)


        
        
        let stackView = UIStackView()
        stackView.axis  = NSLayoutConstraint.Axis.horizontal
        stackView.distribution  = UIStackView.Distribution.equalSpacing
        stackView.alignment = UIStackView.Alignment.bottom
        stackView.spacing   = 16.0
        
        stackView.addArrangedSubview(buyLabel)
        stackView.addArrangedSubview(sellLabel)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        sellLabel.translatesAutoresizingMaskIntoConstraints = false
        secondCurrencyView.translatesAutoresizingMaskIntoConstraints = false
        firstCurrencyView.translatesAutoresizingMaskIntoConstraints = false
        swipeButton.translatesAutoresizingMaskIntoConstraints = false
        greyView.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(greyView)
        NSLayoutConstraint.activate([
            greyView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            greyView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            greyView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            greyView.bottomAnchor.constraint(equalTo: greyView.topAnchor, constant: 240)
            
        ])
        
        view.addSubview(secondCurrencyView)
        NSLayoutConstraint.activate([
            secondCurrencyView.rightAnchor.constraint(equalTo: greyView.rightAnchor, constant: -10),
            secondCurrencyView.leftAnchor.constraint(equalTo: greyView.leftAnchor, constant: 10),
            secondCurrencyView.topAnchor.constraint(equalTo: greyView.topAnchor, constant: 12),
            secondCurrencyView.bottomAnchor.constraint(equalTo: secondCurrencyView.topAnchor, constant: 80)
            
        ])
        
        view.addSubview(swipeButton)
        NSLayoutConstraint.activate([
            swipeButton.leftAnchor.constraint(equalTo: greyView.leftAnchor, constant: 0),
            swipeButton.topAnchor.constraint(equalTo: secondCurrencyView.bottomAnchor, constant: 0)
            
        ])
        
        view.addSubview(firstCurrencyView)
        NSLayoutConstraint.activate([
            firstCurrencyView.rightAnchor.constraint(equalTo: secondCurrencyView.rightAnchor, constant: 0),
            firstCurrencyView.leftAnchor.constraint(equalTo: secondCurrencyView.leftAnchor, constant: 0),
            firstCurrencyView.topAnchor.constraint(equalTo: swipeButton.bottomAnchor, constant: 6),
            firstCurrencyView.bottomAnchor.constraint(equalTo: firstCurrencyView.topAnchor, constant: 80)
            
        ])
        
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
            stackView.leftAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            stackView.topAnchor.constraint(equalTo: greyView.bottomAnchor, constant: 22),
            stackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.04)
        ])
        
        view.addSubview(dateLabel)
        NSLayoutConstraint.activate([
            dateLabel.heightAnchor.constraint(equalToConstant: 18),
            dateLabel.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 0),
            dateLabel.rightAnchor.constraint(equalTo: stackView.leftAnchor, constant: 0),
            dateLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30)
        ])
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            tableView.rightAnchor.constraint(equalTo: stackView.rightAnchor, constant: 0),
            tableView.leftAnchor.constraint(equalTo: dateLabel.leftAnchor, constant: 0)
        ])
    }
    
    func hideKeyboardOnTap() {
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
    func calculateSums(numberCountry: String) {
        if numberCountry == "First" {
            secondCurrencyView.sumTextField.text = presenter.calculate(amountString: firstCurrencyView.sumTextField.text ?? "0.00", fromCountry: firstCurrencyView.countryRow, toCountry: secondCurrencyView.countryRow, viewCountry: "Second")
            secondCurrencyView.amount = 0
        } else {
            firstCurrencyView.sumTextField.text = presenter.calculate(amountString: secondCurrencyView.sumTextField.text ?? "0.00", fromCountry: secondCurrencyView.countryRow, toCountry: firstCurrencyView.countryRow, viewCountry: "First")
            firstCurrencyView.amount = 0
        }
    }
    
    func success() {
            self.tableView.reloadData()
        dateLabel.text = presenter.getDate()
       
    }
    
    func failure(error: Error) {
        print(error)
    }
    
    override func viewDidLayoutSubviews() {
        
    }
}

