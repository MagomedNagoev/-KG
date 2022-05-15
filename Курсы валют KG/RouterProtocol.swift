//
//  RouterProtocol.swift
//  Курсы валют KG
//
//  Created by Нагоев Магомед on 27.03.2022.
//

import UIKit

protocol RouterMain {
    var tabBarController: UITabBarController? { get set }
    var assemblyBuilder: AsselderBuilderProtocol? { get set }
}

protocol RouterProtocol: RouterMain {
    func configureViewControllers()
    func popToRootBalancesNavigationController()
    func showCountries(valutes: [Valute]?, storeManager: DataStoreManager)
    func templateNavigationController(image: UIImage,
                                      tabBarItemTitle: String,
                                      rootViewController: UIViewController) -> UINavigationController
}

class Router: RouterProtocol {
    
    var tabBarController: UITabBarController?
    var assemblyBuilder: AsselderBuilderProtocol?
    var mainNavigationController = UINavigationController()
    var balancesNavigationController = UINavigationController()
    
    
    init(tabBarController: UITabBarController, assemblyBuilder: AsselderBuilderProtocol) {
        self.tabBarController = tabBarController
        self.assemblyBuilder = assemblyBuilder
        self.tabBarController?.configLaunch()
    }
    
    
    func templateNavigationController(image: UIImage,
                                      tabBarItemTitle: String,
                                      rootViewController: UIViewController) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.tabBarItem.image = image
        navigationController.navigationBar.barTintColor = UIColor(red: 52/255,
                                                                  green: 52/255,
                                                                  blue: 52/255,
                                                                  alpha: 1)
        navigationController.tabBarItem.title = tabBarItemTitle
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.shadowImage = UIImage()
        return navigationController
    }
    
    func configureViewControllers() {
        if let tabBarController = tabBarController {
            
            let configuration = UIImage.SymbolConfiguration(pointSize: 18, weight: .light, scale: .large)
            let imageBanknote = UIImage(systemName: "arrow.triangle.2.circlepath", withConfiguration: configuration)
            let imageCase = UIImage(systemName: "briefcase.fill", withConfiguration: configuration)
            guard let mainViewController = assemblyBuilder?.createMainModule(router: self),
                  let balancesViewController = assemblyBuilder?.createBalancesModule(router: self)
                  else { return }
            mainNavigationController = templateNavigationController(image:
                                         imageBanknote!,
                                         tabBarItemTitle: "Курсы валют",
                                         rootViewController: mainViewController)
            
            balancesNavigationController = templateNavigationController(image:                                imageCase!,
                                         tabBarItemTitle: "Мои счета",
                                         rootViewController: balancesViewController)
            
            
            tabBarController.viewControllers = [mainNavigationController,balancesNavigationController]
        }
    }
    
    func showCountries(valutes: [Valute]?, storeManager: DataStoreManager) {
            guard let countriesTableViewController =
                    assemblyBuilder?.createCountriesModule(valutes: valutes, router: self, storeManager: storeManager)
            else { return }
        balancesNavigationController.pushViewController(countriesTableViewController, animated: true)
    }

    func popToRootBalancesNavigationController() {
            balancesNavigationController.popToRootViewController(animated: true)
    }
    
}
