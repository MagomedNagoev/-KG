//
//  CountriesPresenter.swift
//  Курсы валют KG
//
//  Created by Нагоев Магомед on 14.04.2022.
//

import UIKit

protocol CountriesViewProtocol: class {
    func setCountries(valutes: [Valute]?)
}

protocol CountriesPresenterProtocol {
    var valutes: [Valute]? { get set }
    init(view: CountriesViewProtocol, router: RouterProtocol, rateService: RateServiceProtocol, valutes: [Valute]?)
    func setCountries()
    func tap()
    func addRate(name: String, amount: String)
}

class CountriesPresenter: CountriesPresenterProtocol {
    var view: CountriesViewProtocol?
    var router: RouterProtocol?
    var rateService: RateServiceProtocol!
    var valutes: [Valute]?
    
    required init(view: CountriesViewProtocol, router: RouterProtocol, rateService: RateServiceProtocol, valutes: [Valute]?) {
        self.view = view
        self.router = router
        self.valutes = valutes
        self.rateService = rateService
    }
    
    func setCountries() {
        view?.setCountries(valutes: valutes)
    }
    
    func tap() {
        router?.popToRootBalancesNavigationController()
    }
    
    func addRate(name: String, amount: String) {
        rateService.addRate(name: name, amount: amount)
    }
}
