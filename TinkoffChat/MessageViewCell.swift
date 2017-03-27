//
//  MessageViewCell.swift
//  TinkoffChat
//
//  Created by Denis Karpenko on 27.03.17.
//  Copyright © 2017 Denis Karpenko. All rights reserved.
//

import UIKit

class MessageViewCell: UITableViewCell {

    
    @IBOutlet weak var messageLabel: UILabel!
    var msgText:String?{
        didSet{
            messageLabel.text = msgText
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
