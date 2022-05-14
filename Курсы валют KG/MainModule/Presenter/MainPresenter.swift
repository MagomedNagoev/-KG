//
//  MainPresenter.swift
//  Курсы валют KG
//
//  Created by Нагоев Магомед on 18.03.2022.
//

import UIKit

protocol MainViewProtocol: class {
    func success()
    func failure(error: Error)
    func calculateSums(numberCountry: String)
}

protocol MainPresenterProtocol: class {
    var valutes: [Valute]? { get set }
    var amount: Int { get set }
    var countryRows: (Int, Int) { get set }
    var view: MainViewProtocol? { get set }
    func getRates()
    func convertIntSum(amountString: String, currency: String, selectedSegmentIndex: Int) -> String
    func convertKgsSum(amountString: String, currency: String, selectedSegmentIndex: Int) -> String
    func getRatesWoKgs() -> [Valute]?
    func calculate(amountString: String,
                   fromCountry: Int,
                   toCountry: Int,
                   viewCountry: String) -> String
    init(view: MainViewProtocol,networkService: NetworkServiceProtocol, router: RouterProtocol)
}

class MainPresenter: MainPresenterProtocol {
    var countryRows: (Int, Int) = (0, 1)
    var amount = 0
    weak var view: MainViewProtocol?
    var valutes: [Valute]?
    let networkService: NetworkServiceProtocol!
    var router: RouterProtocol?
    
    required init(view: MainViewProtocol,
                  networkService: NetworkServiceProtocol,
                  router: RouterProtocol) {
        self.view = view
        self.networkService = networkService
        self.router = router
        getRates()
    }
    
    public func convertIntSum(amountString: String, currency: String, selectedSegmentIndex: Int) -> String {
        var sum = 0.00
        let amount = Double(amountString.filter {$0 != ","}) ?? 0.00
        guard let valute = valutes?.filter({ $0.titleAlias == currency }).first  else { return "\(sum)" }
        if selectedSegmentIndex == 0 {
            sum = amount * (Double(valute.rates?.sellRate ?? "") ?? 0.00) * 100
        } else {
            sum = amount * (Double(valute.rates?.buyRate ?? "") ?? 0.00) * 100
        }
        
        return "\(sum)".asCurrency(locale: Locale.current) ?? ""
    }
    
    public func convertKgsSum(amountString: String, currency: String, selectedSegmentIndex: Int) -> String {
        var sum = 0.00
        let amount = Double(amountString.filter {$0 != ","}) ?? 0.00
        guard let valute = valutes?.filter({ $0.titleAlias == currency }).first  else { return "\(sum)" }
        if selectedSegmentIndex == 0 {
            sum = amount / (Double(valute.rates?.sellRate ?? "") ?? 0.00) * 100
        } else {
            sum = amount / (Double(valute.rates?.buyRate ?? "") ?? 0.00) * 100
        }
        
        return "\(sum)".asCurrency(locale: Locale.current) ?? ""
    }
    
    func getRatesWoKgs() -> [Valute]? {
        let valutes = self.valutes?.filter({$0.titleAlias != "kgs"})
        return valutes
    }
    
    func getRates() {
        networkService.getComments { [weak self] result in
            guard let self = self else {return}
            DispatchQueue.main.async {
                switch result {
                case .success(let dataValutes):
                    if let newValutes = dataValutes?.data {
                        let sortValutes = newValutes.sorted {$0.0 < $1.0}
                        let arrayValutes = sortValutes.map {$0.value}
                        self.valutes = arrayValutes
                        self.valutes?.insert(Valute(title: "Киргизский сом", titleAlias: "kgs", id: "1", rates: Rates(buyRate: "1", sellRate: "1", dateStart: "")), at: 0)
                    }
                    self.view?.success()
                case .failure(let error):
                    self.view?.failure(error: error)
                }
            }
        }
    }
    
    func calculate(amountString: String,
                   fromCountry: Int,
                   toCountry: Int, viewCountry: String) -> String {
        guard var sum = Double(amountString.filter({$0 != ","})) else {
            return ""
        }
        guard let valutes = valutes else { print("Valutes is nil")
            return "0.00" }
        if let valuteFromCountry = valutes[fromCountry].rates,
           let valuteToCountry = valutes[toCountry].rates,
           let buyRateFromCountry = Double(valuteFromCountry.buyRate ?? "0.00"),
           let sellRateFromCountry = Double(valuteFromCountry.sellRate ?? "0.00"),
           let sellRateToCountry = Double(valuteToCountry.sellRate ?? "0.00"),
           let buyRateToCountry = Double(valuteToCountry.buyRate ?? "0.00") {
            if viewCountry == "First" {
                sum = sum * buyRateFromCountry / sellRateToCountry
            } else {
                sum = sum * sellRateFromCountry / buyRateToCountry
            }
        }
        
        let sumString = Formatter.currency.string(from: NSNumber(value: sum)) ?? "0.00"
        return  sumString
    }

    

}
