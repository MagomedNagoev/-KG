//
//  AppDelegate.swift
//  Курсы валют KG
//
//  Created by Нагоев Магомед on 18.03.2022.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let tabBarController = UITabBarController()
        let assemblyBuilder = AsselderModelBuilder()
        let router = Router(tabBarController: tabBarController,
                            assemblyBuilder: assemblyBuilder)
        router.configureViewControllers()
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        return true
    }

}

