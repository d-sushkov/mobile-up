//
//  MainViewController.swift
//  MobileUp
//
//  Created by Denis Sushkov on 18.10.2020.
//

import UIKit

class MainViewController: UITableViewController {
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    private let manager = APIManager()
    
    private let noResultsLabel: UILabel = {
        let label = UILabel()
        label.text = "Nothing found"
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(MessageTableViewCell.nib(),
                           forCellReuseIdentifier: MessageTableViewCell.identifier)
        progressBar.observedProgress = manager.progress
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        noResultsLabel.frame = CGRect(x: 0, y: 0,
                                      width: tableView.bounds.size.width,
                                      height: tableView.bounds.size.height)
        // updating data is called here to prevent
        // calling UIAlertControllers by
        // detached ViewController
        beginUpdatingData()
    }
    
    @IBAction func pullToRefresh(_ sender: UIRefreshControl) {
        beginUpdatingData()
    }
    
    /// beginUpdatingData()
    ///
    /// Shows progress bar and starts (another) data fetching
    private func beginUpdatingData() {
        manager.progress.completedUnitCount = 0
        progressBar.alpha = 1.0
        manager.makeAPICall { [weak self] result in
            switch result {
            case .failure(let error):
                self?.didFailAPICall(with: error as! APICallError)
            case .success(_):
                self?.didUpdateData()
            }
        }
    }
}

// MARK: - Table View Methods
extension MainViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manager.result?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MessageTableViewCell.identifier) as? MessageTableViewCell else {
            return UITableViewCell()
        }
        if let model = manager.result?[indexPath.row] {
            cell.configure(with: model)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}

// MARK: - API Manager Delegate Methods
extension MainViewController {//: APIManagerDelegate {
    
    /// managerDidUpdateData()
    ///
    /// Checks if API call result was not empty
    /// and updates UI with data model
    func didUpdateData() {
        setPlaceholderVisibility()
        tableView.reloadData()
        tableView.refreshControl?.endRefreshing()
        UIView.animate(withDuration: 1.5) { () -> Void in
            self.progressBar.alpha = 0.0
        }
    }
    
    func didFailAPICall(with error: APICallError) {
        refreshControl?.endRefreshing()
        progressBar.alpha = 0.0
        switch error.kind {
        case .connectionLost:
            showAlert(titleText: "No internet connection", alertMessage: "")
        case .dataTaskFailed:
            if let httpResponse = error.response as? HTTPURLResponse, 500...599 ~= httpResponse.statusCode {
                showAlert(titleText: "No connection to server", alertMessage: "Please, try again later")
            } else {
                fallthrough
            }
        default:
            showAlert(titleText: "Something went wrong", alertMessage: "Please, try again later")
        }
    }
    
    private func setPlaceholderVisibility() {
        if manager.result?.count == 0 {
            tableView.backgroundView = noResultsLabel
            tableView.separatorStyle = .none
        } else {
            tableView.backgroundView = nil
            tableView.separatorStyle = .singleLine
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
