//
//  MainViewController.swift
//  MobileUp
//
//  Created by Denis Sushkov on 18.10.2020.
//

import UIKit

class MainViewController: UITableViewController {
    
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
        
        manager.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        noResultsLabel.frame = CGRect(x: 0, y: 0,
                                    width: tableView.bounds.size.width,
                                    height: tableView.bounds.size.height)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        manager.fetchMessageData()
    }

}
