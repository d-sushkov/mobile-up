//
//  MainVC+TableView.swift
//  MobileUp
//
//  Created by Denis Sushkov on 18.10.2020.
//

import UIKit

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
