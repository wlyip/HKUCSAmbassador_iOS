//
//  UserCell.swift
//  CS Ambassador
//
//  Created by Winnie Yip on 9/4/2021.
//

import UIKit

class UserCell: UITableViewCell {
    
    static let identifier = "messageID2"
    
    var messageText: String? {
        didSet {
            guard let text = messageText else {return}
            let w = messageFrame(text: text).width + 15
            userMessageTextViewConstraint.constant = w
            userMessageTextView.text = text
        }
    }

    @IBOutlet weak var userMessageTextView: UITextView!
    
    @IBOutlet weak var userMessageTextViewConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userMessageTextView.layer.cornerRadius = 16
        backgroundColor = .clear
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func messageSender() {
        //Todo
    }
    
    private func messageFrame(text: String) -> CGRect {
        return NSString(string: text).boundingRect(with: CGSize(width: 250, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)], context: nil)
    }
}
