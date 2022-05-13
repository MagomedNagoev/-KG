//
//  BalancesViewController.swift
//  Курсы валют KG
//
//  Created by Нагоев Магомед on 27.03.2022.
//

import UIKit
import CoreData

class BalancesViewController: UIViewController, UITextFieldDelegate {
    
    public var countryImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "kgs")
        imageView.clipsToBounds = true
        imageView.backgroundColor = .orange
        return imageView
    }()
    
    public var valuteFullNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.tintColor = .clear
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = "Киргизский сом"

        return label
    }()
    
    public var totalSum: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.tintColor = .clear
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24)
        label.text = "0.00 KGS"

        return label
    }()
    
    public var tableView = UITableView()
    public var presenter: BalancesPresenterProtocol!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTargets()
        countryImage.isUserInteractionEnabled = true
        UIconfig()
//        upView()
        setupDismissKeyboardGesture()
        setupKeyboardHiding()
        hideKeyboardOnTap()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func UIconfig() {
        
        view.backgroundColor = UIColor(red: 52/255,
                                       green: 52/255,
                                       blue: 52/255,
                                       alpha: 1)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(addOrderTapped))
        
        let fetchResult = presenter.resultController() as! NSFetchedResultsController<Rate>
        fetchResult.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(BalanceCell.self, forCellReuseIdentifier: BalanceCell.identifier)
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        countryImage.translatesAutoresizingMaskIntoConstraints = false
        valuteFullNameLabel.translatesAutoresizingMaskIntoConstraints = false
        totalSum.translatesAutoresizingMaskIntoConstraints = false
        
        
        view.addSubview(countryImage)
        NSLayoutConstraint.activate([
            countryImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            countryImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            countryImage.heightAnchor.constraint(equalToConstant: 80),
            countryImage.widthAnchor.constraint(equalToConstant: 80),
            countryImage.bottomAnchor.constraint(equalTo: countryImage.topAnchor, constant: 80)
        ])

        countryImage.layer.cornerRadius = 80/2
        
        view.addSubview(valuteFullNameLabel)
        NSLayoutConstraint.activate([
            valuteFullNameLabel.topAnchor.constraint(equalTo: countryImage.bottomAnchor, constant: 5),
            valuteFullNameLabel.rightAnchor.constraint(equalTo: view.rightAnchor),
            valuteFullNameLabel.leftAnchor.constraint(equalTo: view.leftAnchor),
            valuteFullNameLabel.bottomAnchor.constraint(equalTo: valuteFullNameLabel.topAnchor, constant: 20),
        ])
        
        view.addSubview(totalSum)
        NSLayoutConstraint.activate([
            totalSum.topAnchor.constraint(equalTo: valuteFullNameLabel.bottomAnchor, constant: 5),
            totalSum.rightAnchor.constraint(equalTo: view.rightAnchor),
            totalSum.leftAnchor.constraint(equalTo: view.leftAnchor),
            totalSum.bottomAnchor.constraint(equalTo: totalSum.topAnchor, constant: 20),
        ])
        
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: totalSum.bottomAnchor, constant: 50),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        

    }
    
    @objc func addOrderTapped() {
        presenter.tapOntheCountry()
    }
    
}

extension BalancesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.getRates().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BalanceCell.identifier, for: indexPath) as? BalanceCell else {
            return UITableViewCell()
        }

        let rate = presenter.getRate(index: indexPath)
        cell.setData(nameValute: rate.country, amount:rate.amount, presenter: presenter, index: indexPath)
//        cell.amountTextField.delegate = self
//        cell.amountTextField.addTarget(self, action: #selector(refreshSum), for: .editingChanged)
        return cell
    }
    
//    @objc
//    func refreshSum() {
//        let rate = presenter.getRate(index: index)
//            rate.amount = updateTextField()
//        presenter.saveRate()
//        print("\(presenter.summuriseValute())")
//        totalSum.text = "\(presenter.summuriseValute())"
//    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        presenter.tapOntheCountry()
//    }
    
    // MARK: Table View Delegate
    
    func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            presenter.deleteRate(index: indexPath)
        }
    }
    
}

extension BalancesViewController: BalancesViewProtocol {
    func success() {
        tableView.reloadData()
        totalSum.text = "\(presenter.summuriseValute())"
    }
    
    func failure(error: Error) {
        print(error)
    }
    
    func labelRefresh() {
        totalSum.text = "\(presenter.summuriseValute())"
    }
}
