//
//  CardButtonCell.swift
//  CS Ambassador
//
//  Created by Winnie Yip on 10/4/2021.
//

import UIKit

protocol CardButtonViewClick {
    func onClickCardButton(index: Int)
}

class CardButtonCell: UITableViewCell {
    
    static let identifier = "messageID5"
    
    var cellDelegate: CardButtonViewClick?
    var index: IndexPath?
    
    @IBOutlet weak var cardButtonView: UIButton!
    @IBAction func clickCardButton(_ sender: Any) {
        cellDelegate?.onClickCardButton(index: (index?.row)!)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cardButtonView.layer.cornerRadius = 16
        
        backgroundColor = .clear
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
