//
//  UIViewController+Alert.swift
//  MobileUp
//
//  Created by Denis Sushkov on 20.10.2020.
//

import UIKit

extension UIViewController {
    
    func showAlert(titleText: String, alertMessage: String) {
        let alert = UIAlertController(title: titleText, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
