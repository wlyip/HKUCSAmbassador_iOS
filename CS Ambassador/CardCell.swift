//
//  CardCell.swift
//  CS Ambassador
//
//  Created by Winnie Yip on 10/4/2021.
//

import UIKit

class CardCell: UITableViewCell {
    
    static let identifier = "messageID45"
    
    
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var cardTitleView: UITextView!
    @IBOutlet weak var cardSubView: UITextView!
    @IBOutlet weak var cardButtonView: UIButton!
    @IBOutlet weak var cardButtonView2: UIButton!
    @IBOutlet weak var cardButtonView3: UIButton!
    @IBOutlet weak var cardButtonView4: UIButton!
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var cardHeightConstraint: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cardButtonView.layer.cornerRadius = 16
        cardButtonView2.layer.cornerRadius = 16
        cardButtonView3.layer.cornerRadius = 16
        cardButtonView4.layer.cornerRadius = 16
        /*cardView.frame = self.bounds
        cardView.autoresizingMask = [.flexibleHeight]
        autoresizingMask = .flexibleHeight*/
        
        backgroundColor = .clear
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
