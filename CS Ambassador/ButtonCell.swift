//
//  ButtonCell.swift
//  CS Ambassador
//
//  Created by Winnie Yip on 10/4/2021.
//

import UIKit

protocol ButtonViewClick {
    func onClickButton(index: Int)
}

class ButtonCell: UITableViewCell {
    
    static let identifier = "messageID3"
    
    var cellDelegate: ButtonViewClick?
    var index: IndexPath?
    
    @IBOutlet weak var buttonView: UIButton!
    
    @IBAction func clickButton(_ sender: Any) {
        cellDelegate?.onClickButton(index: (index?.row)!)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        buttonView.layer.cornerRadius = 16
        backgroundColor = .clear
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
