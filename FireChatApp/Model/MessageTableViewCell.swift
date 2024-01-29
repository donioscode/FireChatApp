//
//  MessageTableViewCell.swift
//  FireChatApp
//
//  Created by doniyor normuxammedov on 07/12/23.
//

import UIKit
import FirebaseFirestore
import FirebaseCore
import FirebaseAuth

class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var youLB: UILabel!
    @IBOutlet weak var messageLB: UILabel!
    
    @IBOutlet weak var senderLB: UILabel!
    
    @IBOutlet weak var messageView: UIView!
    
    @IBOutlet weak var senderView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        messageView.layer.cornerRadius = messageView.frame.size.height / 5

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


    }
    
    func configure(message: Message){
        
        if Auth.auth().currentUser?.email == message.sender{
            youLB.isHidden = true
            senderLB.isHidden = false
        }else{
            youLB.isHidden = false
            senderLB.isHidden = true
        }
        messageLB.text = message.message
    }
    
}
