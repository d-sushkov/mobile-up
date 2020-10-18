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
        
        manager.delegate = self
        manager.fetchMessageData()
    }

}
