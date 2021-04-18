//
//  AudioCell.swift
//  CS Ambassador
//
//  Created by Winnie Yip on 18/4/2021.
//

import UIKit

protocol AudioClick {
    func onClickAudio(index: Int)
}

class AudioCell: UITableViewCell {
    
    static let identifier = "messageID6"
    
    var cellDelegate: AudioClick?
    var index: IndexPath?
    
    @IBOutlet weak var audioButtonView: UIButton!
    
    @IBAction func clickAudioButton(_ sender: Any) {
        cellDelegate?.onClickAudio(index: (index?.row)!)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        audioButtonView.layer.cornerRadius = 20
        backgroundColor = .clear
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
