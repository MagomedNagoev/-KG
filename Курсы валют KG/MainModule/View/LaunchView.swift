//
//  LaunchView.swift
//  Курсы валют KG
//
//  Created by Нагоев Магомед on 14.05.2022.
//
import UIKit


class LaunchView: UIView {
    
    private var logoView = UIImageView()
    private var fume1Image = UIImageView()
    private var fume2Image = UIImageView()
    private var fume3Image = UIImageView()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
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
//        addSubview(logoView)
//        addSubview(fume1Image)
//        addSubview(fume2Image)
//        addSubview(fume3Image)
//
//        logoView.image = UIImage(named: "Iron")
//        fume1Image.image = UIImage(named: "fume")
//        fume2Image.image = UIImage(named: "fume")
//        fume3Image.image = UIImage(named: "fume")
//        setupConstraints()
//        presentWeatherVC()
    }

//    func setupConstraints() {
//        logoView.translatesAutoresizingMaskIntoConstraints = false
//        fume1Image.translatesAutoresizingMaskIntoConstraints = false
//        fume2Image.translatesAutoresizingMaskIntoConstraints = false
//        fume3Image.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            logoView.centerYAnchor.constraint(equalTo: centerYAnchor),
//            logoView.centerXAnchor.constraint(equalTo: centerXAnchor),
//            logoView.heightAnchor.constraint(equalToConstant: 480),
//            logoView.widthAnchor.constraint(equalToConstant: 270)
//        ])
//
//        NSLayoutConstraint.activate([
//            fume1Image.centerYAnchor.constraint(equalTo: logoView.centerYAnchor, constant: 28),
//            fume1Image.centerXAnchor.constraint(equalTo: logoView.centerXAnchor, constant: -3),
//            fume1Image.heightAnchor.constraint(equalToConstant: 13.7),
//            fume1Image.widthAnchor.constraint(equalToConstant: 13.9)
//        ])
//
//        NSLayoutConstraint.activate([
//            fume2Image.centerYAnchor.constraint(equalTo: logoView.centerYAnchor, constant: 28),
//            fume2Image.trailingAnchor.constraint(equalTo: fume1Image.leadingAnchor, constant: 2),
//            fume2Image.heightAnchor.constraint(equalToConstant: 13.7),
//            fume2Image.widthAnchor.constraint(equalToConstant: 13.9)
//        ])
//
//        NSLayoutConstraint.activate([
//            fume3Image.centerYAnchor.constraint(equalTo: logoView.centerYAnchor, constant: 28),
//            fume3Image.leadingAnchor.constraint(equalTo: fume1Image.trailingAnchor, constant: -2),
//            fume3Image.heightAnchor.constraint(equalToConstant: 13.7),
//            fume3Image.widthAnchor.constraint(equalToConstant: 13.9)
//        ])
//
//    }
    
    
        func presentMainVC() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.removeFromSuperview()
        }
    }
}
