//
//  CardButtonCell.swift
//  CS Ambassador
//
//  Created by Winnie Yip on 10/4/2021.
//

import UIKit

class CardButtonCell: UITableViewCell {
    
    static let identifier = "messageID5"
    
    
    @IBOutlet weak var cardButtonView: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cardButtonView.layer.cornerRadius = 16
        
        backgroundColor = .clear
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
