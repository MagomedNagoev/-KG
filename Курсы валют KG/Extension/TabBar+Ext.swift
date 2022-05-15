//
//  TabBar+Ext.swift
//  Курсы валют KG
//
//  Created by Нагоев Магомед on 14.05.2022.
//

import UIKit

extension UITabBarController {
    
    func configLaunch() {
        print("new")
        let splashView = LaunchView()
        self.tabBar.backgroundColor = #colorLiteral(red: 0.203900069, green: 0.2039352655, blue: 0.2038924694, alpha: 1)
        self.tabBar.barStyle = .black
        self.tabBar.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        let a = UIImageView()
        a.backgroundColor = .yellow
        self.tabBar.selectionIndicatorImage = a.image
        view.addSubview(splashView)
        splashView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
    }
}
