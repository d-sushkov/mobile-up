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
    private var accessoryButton: UIButton?
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var senderNameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var messageTextLabel: UILabel!
    
    static func nib() -> UINib {
        return UINib(nibName: "MessageTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        accessoryType = .disclosureIndicator
        accessoryButton = subviews.compactMap { $0 as? UIButton }.first
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        accessoryButton?.frame.origin.y = 13
    }
    
    /// configure(with model: APIModel)
    ///
    /// Configures the cell's contents
    /// with result from API call
    ///
    /// Parameters   : model: Data model for configuration
    func configure(with model: APIModel) {
        avatarImageView.sd_setImage(with: URL(string: model.user.avatarURL),
                                    placeholderImage: UIImage(named: "userImage"))
        senderNameLabel.text = model.user.nickname
        messageTextLabel.text = model.message.text
        timestampLabel.text = model.message.shownDate
    }
    
}
