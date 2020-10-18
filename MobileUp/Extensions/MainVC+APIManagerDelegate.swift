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
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.tableView.refreshControl?.endRefreshing()
            UIView.animate(withDuration: 1.5) { () -> Void in
                self.progressBar.alpha = 0.0
            }
        }
    }
    
    /// managerDidFailWithError(response: URLResponse?)
    ///
    /// Checks if error was on a client or server side
    /// and presents the appropriate alert
    ///
    /// Parameters   : response: API call URL response
    func managerDidFailWithError(response: URLResponse?) {
        stopUpdatingData()
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
        stopUpdatingData()
        showAlert(titleText: "No internet connection", alertMessage: "")
    }
    
    /// stopUpdatingData()
    ///
    /// Hides refresh control and progress bar
    private func stopUpdatingData() {
        DispatchQueue.main.async {
            self.refreshControl?.endRefreshing()
            self.progressBar.alpha = 0.0
        }
    }
    
    /// showPlaceholder()
    ///
    /// Adds placeholder to tableView background
    private func showPlaceholder() {
        DispatchQueue.main.async {
            self.tableView.backgroundView = self.noResultsLabel
            self.tableView.separatorStyle = .none
        }
    }
    
    /// hidePlaceholder()
    ///
    /// Removes placeholder from tableView background
    private func hidePlaceholder() {
        DispatchQueue.main.async {
            self.tableView.backgroundView = nil
            self.tableView.separatorStyle = .singleLine
        }
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
