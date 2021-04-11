//
//  CardInfoCell.swift
//  CS Ambassador
//
//  Created by Winnie Yip on 10/4/2021.
//

import UIKit

class CardInfoCell: UITableViewCell {
    
    static let identifier = "messageID4"

    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var cardTitleView: UITextView!
    @IBOutlet weak var cardSubView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
