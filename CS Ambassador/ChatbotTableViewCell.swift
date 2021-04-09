//
//  ChatbotTableViewCell.swift
//  CS Ambassador
//
//  Created by Winnie Yip on 9/4/2021.
//

import UIKit

class ChatbotTableViewCell: UITableViewCell {
    
    static let identifier = "messageID"
    
    var messageText: String? {
        didSet {
            guard let text = messageText else {return}
            let w = messageFrame(text: text).width + 15
            messageTextViewConstraint.constant = w
            botMessageTextView.text = text
        }
    }
    /*var messageText: Msg? {
        didSet {
            guard let text = messageText?.message else {return}
            let w = messageFrame(text: text).width + 15
            messageTextViewConstraint.constant = w
            botMessageTextView.text = text
        }
    }*/
    
    @IBOutlet weak var botMessageTextView: UITextView!
    
    @IBOutlet weak var messageTextViewConstraint: NSLayoutConstraint!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        botMessageTextView.layer.cornerRadius = 16
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
