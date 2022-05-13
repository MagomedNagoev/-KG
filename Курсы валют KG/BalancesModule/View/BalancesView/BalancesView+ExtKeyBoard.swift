//
//  BalancesView + Ext KeyBoard.swift
//  Курсы валют KG
//
//  Created by Нагоев Магомед on 09.04.2022.
//

import UIKit
extension BalancesViewController {
    
    // MARK: Keyboard
    
    func setupDismissKeyboardGesture() {
        let dismissKeyboardTap = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_: )))
        view.addGestureRecognizer(dismissKeyboardTap)
    }
    
    @objc func viewTapped(_ recognizer: UITapGestureRecognizer) {
        view.endEditing(true) // resign first responder
    }
    
    func setupKeyboardHiding() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        guard let userInfo = sender.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
              let currentTextField = UIResponder.currentFirst() as? UITextField else { return }
        
        let keyboardTopY = keyboardFrame.cgRectValue.origin.y
        let convertedTextFieldFrame = view.convert(currentTextField.frame, from: currentTextField.superview)
        let textFieldBottomY = convertedTextFieldFrame.origin.y + convertedTextFieldFrame.size.height + (navigationController?.tabBarController?.tabBar.frame.size.height ?? 0)
        
        if textFieldBottomY >= keyboardTopY {
            let textBoxY = convertedTextFieldFrame.origin.y - (navigationController?.tabBarController?.tabBar.frame.size.height ?? 0)
            
            
            let newFrameY = (textBoxY - keyboardTopY / 2) * -1
            view.frame.origin.y = newFrameY + (navigationController?.navigationBar.frame.size.height ?? 0) + (navigationController?.navigationBar.frame.origin.y ?? 0) + 60
            

        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = (navigationController?.navigationBar.frame.origin.y ?? 0) + (navigationController?.navigationBar.frame.size.height ?? 0)
    }
    func hideKeyboardOnTap()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(self.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
