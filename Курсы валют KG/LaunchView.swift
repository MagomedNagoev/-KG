//
//  LaunchView.swift
//  Курсы валют KG
//
//  Created by Нагоев Магомед on 14.05.2022.
//

import UIKit


class LaunchView: UIView {
    
    private var logoView = UIImageView()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
        uiConfig()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func uiConfig(){
        backgroundColor = UIColor(red: 62/255,
                                  green: 62/255,
                                  blue: 63/255,
                                  alpha: 1)
        addSubview(logoView)

        logoView.image = UIImage(named: "plant")

        setupConstraints()
        presentWeatherVC()
    }

    func setupConstraints() {
        logoView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            logoView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0),
            logoView.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoView.heightAnchor.constraint(equalToConstant: 234),
            logoView.widthAnchor.constraint(equalToConstant: 128.7)
        ])
    }
    
    
        func presentWeatherVC() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.removeFromSuperview()
        }
    }
}


