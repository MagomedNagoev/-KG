//
//  CurrencyTextField.swift
//  Курсы валют KG
//
//  Created by Нагоев Магомед on 31.03.2022.
//

import UIKit

class CurrencyTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        clearButtonMode = .never
        keyboardType = .decimalPad
        returnKeyType = .done
        autocorrectionType = .no
        font = UIFont(name: "Montserrat-Light", size: 17)
        textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        contentVerticalAlignment = .center
        textAlignment = .right

        let colorPlaceholderText = NSAttributedString(string: "0.00",
                                                    attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)])
        attributedPlaceholder = colorPlaceholderText
    }
}

extension Formatter {
    static let currency: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = ""
        return formatter
    }()
    
    static let date: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        return formatter
    }()

}

extension String {
    func asCurrency(locale: Locale) -> String? {
        Formatter.currency.locale = locale
        if self.isEmpty {
            return Formatter.currency.string(from: NSNumber(value: 0))
        } else {
            return Formatter.currency.string(from: NSNumber(value: (Double(self) ?? 0) / 100))
        }
    }
}
