//
//  BalancesPresenter.swift
//  Курсы валют KG
//
//  Created by Нагоев Магомед on 01.04.2022.
//

import UIKit

protocol BalancesViewProtocol: class {
    func success()
    func failure(error: Error)
    func labelRefresh()
}


protocol BalancesPresenterProtocol: class {
    var index: Int { get set }
    var valutes: [Valute]? { get set }
    var view: BalancesViewProtocol? { get set }
    init(view: BalancesViewProtocol,networkService: NetworkServiceProtocol, router: RouterProtocol, storeManager: DataStoreManager)
    
    func getData()
    func getRates() -> [Rate]
    func saveRate()
    func deleteRate(index: IndexPath)
    func getRate(index: IndexPath) -> Rate
    func resultController() -> Any
    func tapOntheCountry()
    func summuriseValute() -> String
}

class BalancesPresenter: BalancesPresenterProtocol {
    var index: Int = 0
    var view: BalancesViewProtocol?
    var valutes: [Valute]?
    var storeManager: DataStoreManager!
    var networkService: NetworkServiceProtocol!
    var router: RouterProtocol?
    
    required init(view: BalancesViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol, storeManager: DataStoreManager) {
        self.view = view
        self.networkService = networkService
        self.router = router
        self.storeManager = storeManager
        getData()
    }
    
    func getData() {
        networkService.getAllData { [weak self] result in
            guard let self = self else {return}
            DispatchQueue.main.async {
                switch result {
                case .success(let dataValutes):
                    if let newValutes = dataValutes?.data {
                        let sortValutes = newValutes.sorted {$0.0 < $1.0}
                        let arrayValutes = sortValutes.map {$0.value}
                        self.valutes = arrayValutes
                        self.valutes?.insert(Valute(title: "Киргизский сом", titleAlias: "kgs", id: "1", rates: Rates(buyRate: "1", sellRate: "1", dateStart: "")), at: 0)
//                            .filter {$0.titleAlias != "cny" && $0.titleAlias != "gbp"}
                    }
                    self.view?.success()
                case .failure(let error):
                    self.view?.failure(error: error)
                }
            }
        }

    }
    
    func resultController() -> Any {
        return storeManager.fetchedResultsController
    }
    
    func getRates() -> [Rate] {
        return storeManager.getRates()
    }
    
    func saveRate() {
        storeManager.saveContext(context: storeManager.mainContext)
    }
    
    func deleteRate(index: IndexPath) {
        storeManager.deleteRate(index: index)
    }
    
    func getRate(index: IndexPath) -> Rate {
        return storeManager.getRate(index: index)
    }
    
    func tapOntheCountry() {
        router?.showCountries(valutes: valutes, storeManager: storeManager)
    }
    
    func summuriseValute() -> String {
        var sum = 0.00
        let kgsSum = "\(String(describing: Formatter.currency.string(from: NSNumber(value: sum)))) KGS"
        guard let valutes = valutes else { print("Valutes is nil")
            return kgsSum }
        
        guard let titleLabelValute = valutes[index].titleAlias,
              let sellRateString = valutes[index].rates?.sellRate,
              let sellLabelRate = Double(sellRateString) else {
            return kgsSum
        }
        
        let rates = getRates()
        for rate in rates {
            for valute in valutes {
                if let amount = rate.amount?.removeFormatAmount(),
                   let sellRateString = valute.rates?.buyRate,
                   let sellRate = Double(sellRateString),
                   rate.country == valute.titleAlias {
                    if valute.titleAlias == titleLabelValute {
                        sum += amount
                    } else {
                        sum += amount * sellRate / sellLabelRate
                    }
                }
            }
        }

        
        guard let sumString = Formatter.currency.string(from: NSNumber(value: sum)),
              let titleAlias = valutes[index].titleAlias?.uppercased()
              else { return kgsSum }
        
        let equivalentSum = sumString + " " + titleAlias

        return  equivalentSum
        
    }
    
}
