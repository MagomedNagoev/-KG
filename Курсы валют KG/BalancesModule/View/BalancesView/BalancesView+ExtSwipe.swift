//
//  BalancesView+Ext.swift
//  Курсы валют KG
//
//  Created by Нагоев Магомед on 09.04.2022.
//

import UIKit
extension BalancesViewController {

    // MARK: Swipe
    func addTargets() {
        
        let leftGestuge = UISwipeGestureRecognizer(target: self, action: #selector(leftSwipe))
        leftGestuge.direction = .left

        let rightGestuge = UISwipeGestureRecognizer(target: self, action: #selector(rightSwipe))
        rightGestuge.direction = .right
        
        countryImage.addGestureRecognizer(leftGestuge)
        countryImage.addGestureRecognizer(rightGestuge)
        
    }
    
    @objc func leftSwipe() {
        guard let valutes = presenter.valutes else {
            return
        }
        
        if presenter.index < valutes.count - 1 {
            
            presenter.index += 1 } else { presenter.index = 0 }
        
        UIView.transition(with: countryImage,
                          duration: 0.3,
                          options: .transitionFlipFromRight) { [weak self] in
            guard let self = self else { return }
            
            self.countryImage.image = UIImage(named: valutes[self.presenter.index].titleAlias ?? "kgs")
            self.valuteFullNameLabel.text = valutes[self.presenter.index].title ?? "Киргизский сом"
            self.totalSum.text = self.presenter.summuriseValute()
        }
    }
    
    @objc func rightSwipe() {
        guard let valutes = presenter.valutes else {
            return
        }
        
        if presenter.index > 0 {
            presenter.index -= 1 } else
        { presenter.index = valutes.count - 1
            
        }
        
        UIView.transition(with: countryImage,
                          duration: 0.3,
                          options: .transitionFlipFromLeft) { [weak self] in
            guard let self = self else { return }
            self.countryImage.image = UIImage(named: valutes[self.presenter.index].titleAlias ?? "kgs")
            self.valuteFullNameLabel.text = valutes[self.presenter.index].title ?? "Киргизский сом"
            self.totalSum.text = self.presenter.summuriseValute()
        }
    }
}

