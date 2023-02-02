//
//  NotificationCell.swift
//  Demo
//
//  Created by 呂紹瑜 on 2023/2/2.
//

import UIKit

class NotificationCell: UITableViewCell {


    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var unClickedView: UIView! {
        didSet {
            unClickedView.layer.cornerRadius = 6
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    func configure(model: NotificationModel) {
        unClickedView.isHidden = model.status
        timeLabel.text = model.updateDateTime
        titleLabel.text = model.title
        messageLabel.text = model.message
    }

}

