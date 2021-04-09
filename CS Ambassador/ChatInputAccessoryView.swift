//
//  ChatInputAccessoryView.swift
//  CS Ambassador
//
//  Created by Winnie Yip on 12/1/2021.
//

import UIKit

protocol ChatInputAccessoryViewDelegate: class {
    func clickOnSendButton(text: String)
}

class ChatInputAccessoryView: UIView, UITextViewDelegate {
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var inputBoxView: UITextView!
    @IBAction func clickOnSendButton( _sender: Any){
        guard let text = inputBoxView.text else { return }
        delegate?.clickOnSendButton(text: text)
        inputBoxView.text = String()
    }
    
    weak var delegate: ChatInputAccessoryViewDelegate?
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let nib = UINib(nibName: "ChatInputAccessoryView", bundle: nil)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else {return}
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(view)
        
        inputBoxView.layer.cornerRadius = 15
        
        sendButton.imageView?.contentMode = .scaleAspectFill
        sendButton.contentVerticalAlignment = .fill
        sendButton.contentHorizontalAlignment = .fill
        
        autoresizingMask = .flexibleHeight
        inputBoxView.delegate = self
    }
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
