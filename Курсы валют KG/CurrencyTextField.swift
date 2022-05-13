//
//  CurrencyTextField.swift
//  Курсы валют KG
//
//  Created by Нагоев Магомед on 31.03.2022.
//

import UIKit

class CurrencyTextField: UITextField {
    
    /// The numbers that have been entered in the text field
    public var enteredNumbers = ""

    private var didBackspace = false

    var locale: Locale = .current

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
//        addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        clearButtonMode = .never
        keyboardType = .decimalPad
        returnKeyType = .done
        autocorrectionType = .no
        font = UIFont.systemFont(ofSize: 15)
        textColor = .lightGray
        contentVerticalAlignment = .center
        textAlignment = .right

        let colorPlaceholderText = NSAttributedString(string: "0.00",
                                                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        attributedPlaceholder = colorPlaceholderText
    }

//    override func deleteBackward() {
//        enteredNumbers = String(enteredNumbers.dropLast())
//        text = enteredNumbers.asCurrency(locale: locale)
//        // Call super so that the .editingChanged event gets fired, but we need to handle it differently, so we set the `didBackspace` flag first
//        didBackspace = true
//        super.deleteBackward()
//    }

    @objc func editingChanged() {
        print("Debug: \(enteredNumbers)")
        defer {
            didBackspace = false
            text = enteredNumbers.asCurrency(locale: locale)
        }

        guard didBackspace == false else { return }

        if let lastEnteredCharacter = text?.last, lastEnteredCharacter.isNumber {
            enteredNumbers.append(lastEnteredCharacter)
        }
    }
}

extension Formatter {
    static let currency: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = ""
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
        
        func isValidDouble(maxDecimalPlaces: Int) -> Bool {
            let formatter = NumberFormatter()
            formatter.allowsFloats = true
            let decimalSeparator = formatter.decimalSeparator ?? "."
            if formatter.number(from: self) != nil {
                let split = self.components(separatedBy: decimalSeparator)
                let digits = split.count == 2 ? split.last ?? "" : ""
                return digits.count <= maxDecimalPlaces
            }
            
            return false
        }
}
