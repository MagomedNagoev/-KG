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
        imageView.backgroundColor = .red
        imageView.image = UIImage(named: "kgs")
        imageView.clipsToBounds = true
        imageView.backgroundColor = .orange
        imageView.layer.cornerRadius = 80/2
        return imageView
    }()

    private var leftButton: UIButton = {
      let button = UIButton()
        button.addTarget(self, action: #selector(rightSwipe), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        let configuration = UIImage.SymbolConfiguration(pointSize: 15, weight: .regular, scale: .large)
        let image = UIImage(systemName: "chevron.left", withConfiguration: configuration)?.withTintColor(#colorLiteral(red: 0.7112803895, green: 0.7112803895, blue: 0.7112803895, alpha: 1), renderingMode: .alwaysOriginal)
        button.setImage(image, for: .normal)
        button.heightAnchor.constraint(equalToConstant: 20).isActive = true
        button.widthAnchor.constraint(equalToConstant: 20).isActive = true
        return button
    }()
    
    private var rightButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(leftSwipe), for: .touchUpInside)
          button.translatesAutoresizingMaskIntoConstraints = false
        let configuration = UIImage.SymbolConfiguration(pointSize: 15, weight: .regular, scale: .large)
          let image = UIImage(systemName: "chevron.right", withConfiguration: configuration)?.withTintColor(#colorLiteral(red: 0.7112803895, green: 0.7112803895, blue: 0.7112803895, alpha: 1), renderingMode: .alwaysOriginal)
          button.setImage(image, for: .normal)
          button.heightAnchor.constraint(equalToConstant: 20).isActive = true
          button.widthAnchor.constraint(equalToConstant: 20).isActive = true
          return button
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
        label.textColor = #colorLiteral(red: 0.8410194441, green: 0.8410194441, blue: 0.8410194441, alpha: 1)
        label.tintColor = .clear
        label.textAlignment = .center
        label.font = UIFont(name: "OpenSans-Regular", size: 24)
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
        navigationItem.rightBarButtonItem?.tintColor = .white
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
        
        view.addSubview(leftButton)
        NSLayoutConstraint.activate([
            leftButton.rightAnchor.constraint(equalTo: countryImage.leftAnchor, constant: -10),
            leftButton.centerYAnchor.constraint(equalTo: countryImage.centerYAnchor),
        ])
        
        view.addSubview(rightButton)
        NSLayoutConstraint.activate([
            rightButton.leftAnchor.constraint(equalTo: countryImage.rightAnchor, constant: 10),
            rightButton.centerYAnchor.constraint(equalTo: countryImage.centerYAnchor),
        ])
        
        
        view.addSubview(valuteFullNameLabel)
        NSLayoutConstraint.activate([
            valuteFullNameLabel.topAnchor.constraint(equalTo: countryImage.bottomAnchor, constant: 10),
            valuteFullNameLabel.rightAnchor.constraint(equalTo: view.rightAnchor),
            valuteFullNameLabel.leftAnchor.constraint(equalTo: view.leftAnchor),
            valuteFullNameLabel.bottomAnchor.constraint(equalTo: valuteFullNameLabel.topAnchor, constant: 20),
        ])
        
        view.addSubview(totalSum)
        NSLayoutConstraint.activate([
            totalSum.topAnchor.constraint(equalTo: valuteFullNameLabel.bottomAnchor, constant: 10),
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

        return cell
    }
    
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
