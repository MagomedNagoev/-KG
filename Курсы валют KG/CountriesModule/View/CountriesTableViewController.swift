//
//  CountriesTableViewController.swift
//  Курсы валют KG
//
//  Created by Нагоев Магомед on 14.04.2022.
//

import UIKit

class CountriesTableViewController: UITableViewController, CountriesViewProtocol {

    var presenter: CountriesPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }

    func configUI() {
        
        let backButton = UIBarButtonItem()
        backButton.tintColor = .white
        backButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        tableView.register(CountryCell.self, forCellReuseIdentifier: CountryCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(red: 52/255,
                                            green: 52/255,
                                            blue: 52/255,
                                            alpha: 1)
    }
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.valutes?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CountryCell.identifier, for: indexPath) as? CountryCell else { return UITableViewCell()}

        guard let valute = presenter.valutes?[indexPath.row] else { return cell }
        
        cell.setData(nameValute: valute.titleAlias, fullNameValute: valute.title)
        
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let valuteName = presenter.valutes?[indexPath.row].titleAlias else { return }
        presenter.addRate(name: valuteName, amount: "0.00")
        presenter.tap()
    }
}

