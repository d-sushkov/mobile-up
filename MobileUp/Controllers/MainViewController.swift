//
//  MainViewController.swift
//  MobileUp
//
//  Created by Denis Sushkov on 18.10.2020.
//

import UIKit

class MainViewController: UITableViewController {
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    let manager = APIManager()

    let noResultsLabel: UILabel = {
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
        manager.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        noResultsLabel.frame = CGRect(x: 0, y: 0,
                                            width: tableView.bounds.size.width,
                                            height: tableView.bounds.size.height)
        beginUpdatingData()
    }

    @IBAction func pullToRefresh(_ sender: UIRefreshControl) {
        beginUpdatingData()
    }
    
    /// beginUpdatingData()
    ///
    /// Shows progress bar and starts another data fetching
    private func beginUpdatingData() {
        manager.progress.completedUnitCount = 0
        progressBar.alpha = 1.0
        manager.fetchMessageData()
    }
}
