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
        let angle =  CGFloat(M_PI_2*2)
        let tr = CGAffineTransform.identity.rotated(by: angle)
        self.transform = tr
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configurate(text:String,incoming:Bool){
        msgText = text
        messageLabel.layer.masksToBounds = true
        messageLabel.layer.cornerRadius = 3
        if incoming {
            messageLabel.backgroundColor = UIColor(red: 102/255, green: 178/255, blue: 255/255, alpha: 1)
        }
        else{
            messageLabel.backgroundColor = UIColor(red: 102/255, green: 255/255, blue: 102/255, alpha: 1)
        }
    }
    func configurate(with msg:Message){
        msgText = msg.text
        messageLabel.layer.masksToBounds = true
        messageLabel.layer.cornerRadius = 3
        if msg.reciever?.userId! == UIDevice.current.name { /// CHange!!!
            messageLabel.backgroundColor = UIColor(red: 102/255, green: 178/255, blue: 255/255, alpha: 1)
        }
        else{
            messageLabel.backgroundColor = UIColor(red: 102/255, green: 255/255, blue: 102/255, alpha: 1)
        }
    }

}
