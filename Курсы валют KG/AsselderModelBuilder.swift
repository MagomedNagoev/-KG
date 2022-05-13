//
//  ModuleBuilder.swift
//  Курсы валют KG
//
//  Created by Нагоев Магомед on 18.03.2022.
//

import UIKit

protocol AsselderBuilderProtocol: class {
    func createMainModule(router: RouterProtocol) -> UIViewController
    func createBalancesModule(router: RouterProtocol) -> UIViewController
    func createCountriesModule(valutes: [Valute]?, router: RouterProtocol, storeManager: DataStoreManager) -> UIViewController
}

class AsselderModelBuilder: AsselderBuilderProtocol {
    func createMainModule(router: RouterProtocol) -> UIViewController {
        let view = MainViewController()
        let networkService = NetworkService()
        let presenter = MainPresenter(view: view,
                                      networkService: networkService,
                                      router: router)
        view.presenter = presenter
        return view
    }
    
    func createBalancesModule(router: RouterProtocol) -> UIViewController {
        let view = BalancesViewController()
        let networkService = NetworkService()
        let storeManager = DataStoreManager()
        let presenter = BalancesPresenter(view: view, networkService: networkService, router: router, storeManager: storeManager)
        view.presenter = presenter
        return view
    }
    
    func createCountriesModule(valutes: [Valute]?, router: RouterProtocol, storeManager: DataStoreManager) -> UIViewController {
        let view = CountriesTableViewController()
        let rateService = RateService(managedObjectContext: storeManager.mainContext, dataStoreManager: storeManager)
        let presenter = CountriesPresenter(view: view, router: router, rateService: rateService, valutes: valutes)
        view.presenter = presenter
        return view
    }
}
