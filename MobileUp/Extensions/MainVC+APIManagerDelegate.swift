//
//  MainVC+APIManagerDelegate.swift
//  MobileUp
//
//  Created by Denis Sushkov on 18.10.2020.
//

import UIKit

extension MainViewController: APIManagerDelegate {
    
    /// managerDidUpdateData()
    ///
    /// Checks if API call result was not empty
    /// and updates UI with data model
    func managerDidUpdateData() {
        manager.result?.count == 0 ? showPlaceholder() : hidePlaceholder()
        tableView.reloadData()
//        if manager.result?.count == 0 {
//            tableView.reloadData()
//            showPlaceholder()
//        } else {
//            DispatchQueue.main.async {
//                self.hidePlaceholder()
//                self.tableView.reloadData()
//            }
//        }
    }
    
    /// managerDidFailWithError(response: URLResponse?)
    ///
    /// Checks if error was on a client or server side
    /// and presents the appropriate alert
    ///
    /// Parameters   : response: API call URL response
    func managerDidFailWithError(response: URLResponse?) {
        var title = "Something went wrong"
        if let httpResponse = response as? HTTPURLResponse, 500...599 ~= httpResponse.statusCode {
            title = "No connection to server"
        }
        showAlert(titleText: title, alertMessage: "Please, try again later")
    }
    
    /// managerDidLoseConnection()
    ///
    /// Presents the alert if internet connection was lost
    func managerDidLoseConnection() {
        showAlert(titleText: "No internet connection", alertMessage: "")
    }
    
    /// showPlaceholder()
    ///
    /// Adds placeholder to tableView background
    private func showPlaceholder() {
//        noResultsLabel.frame = CGRect(x: 0, y: 0,
//                                    width: tableView.bounds.size.width,
//                                    height: tableView.bounds.size.height)
        tableView.backgroundView = noResultsLabel
        tableView.separatorStyle = .none
    }
    
    /// hidePlaceholder()
    ///
    /// Removes placeholder from tableView background
    private func hidePlaceholder() {
        tableView.backgroundView = nil
        tableView.separatorStyle = .singleLine
    }
    
    /// showAlert(titleText: String, alertMessage: String)
    ///
    /// Creates and presents UIAlertController
    /// with error text
    ///
    /// Parameters   : titleText: Alert's title text
    ///           : alertMessage: Alert's message text
    private func showAlert(titleText: String, alertMessage: String) {
        let alert = UIAlertController(title: titleText, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
