//
//  MessageTableViewCell.swift
//  MobileUp
//
//  Created by Denis Sushkov on 18.10.2020.
//

import UIKit
import SDWebImage

/// MessageTableViewCell: UITableViewCell
///
/// Custom cell for displaying
/// Message details in UITableView
class MessageTableViewCell: UITableViewCell {
    
    static let identifier = "MessageTableViewCell"

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var senderNameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var messageTextLabel: UILabel!
    
    static func nib() -> UINib {
        return UINib(nibName: "MessageTableViewCell", bundle: nil)
    }
    
    /// configure(with model: APIModel)
    ///
    /// Configures the cell's contents
    /// with result from API call
    ///
    /// Parameters   : model: Data model for configuration
    func configure(with model: APIModel) {
        avatarImageView.sd_setImage(with: URL(string: model.user.avatarURL),
                                    placeholderImage: UIImage(systemName: "person.circle"))
        senderNameLabel.text = model.user.nickname
        messageTextLabel.text = model.message.text
        // Timestamp!
    }
    
}
