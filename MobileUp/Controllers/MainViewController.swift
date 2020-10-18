//
//  MainViewController.swift
//  MobileUp
//
//  Created by Denis Sushkov on 18.10.2020.
//

import UIKit

class MainViewController: UITableViewController {
    
    let manager = APIManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(MessageTableViewCell.nib(),
                           forCellReuseIdentifier: MessageTableViewCell.identifier)
        
        manager.delegate = self
        manager.fetchMessageData()
    }

}
