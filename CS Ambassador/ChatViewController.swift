//
//  ChatViewController.swift
//  CS Ambassador
//
//  Created by Winnie Yip on 10/1/2021.
//

import UIKit
import MessageKit
import InputBarAccessoryView

struct Sender: SenderType {
    var senderId: String
    var displayName: String
}

struct Message: MessageType {
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
    var sender: SenderType
}

class ChatViewController: MessagesViewController, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate, InputBarAccessoryViewDelegate, MessageCellDelegate, ChatInputAccessoryViewDelegate {
    
    var listOfMessages: [MessageType] = []

    let user = Sender(senderId: "user", displayName: "")
    let bot = Sender(senderId: "bot", displayName: "")
    
    lazy var chatInputAccessoryView: ChatInputAccessoryView = {
        let view = ChatInputAccessoryView()
        view.frame = .init(x: 0, y: 0, width: view.frame.width, height: 50)
        view.delegate = self
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
        layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
        layout.textMessageSizeCalculator.incomingAvatarSize = .zero
        }
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
        messageInputBar.delegate = self
        messageInputBar.contentView.backgroundColor = UIColor(hex: 0x506497)
        
        listOfMessages.append(Message(messageId: "1", sentDate: Date(), kind: .text("Welcome, how may I help you?"), sender: bot))
    }
    
    func currentSender() -> SenderType {
        return user
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return listOfMessages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return listOfMessages.count
    }
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        if (message.sender.senderId == "user") {
            return .black
        }
        else {
            return .black
        }
    }

    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        if (message.sender.senderId == "user") {
            return UIColor(hex: 0x6B9CC1)
        }
        else {
            return UIColor(hex: 0xEFEEE5)
        }
    }
    
    func clickOnSendButton(text: String) {
        listOfMessages.append(Message(messageId: String(listOfMessages.count), sentDate: Date(), kind: .text(text), sender: currentSender()))
        messagesCollectionView.insertSections([listOfMessages.count - 1])
        messagesCollectionView.scrollToBottom()
        botResponse(text: text)
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        listOfMessages.append(Message(messageId: String(listOfMessages.count), sentDate: Date(), kind: .text(text), sender: currentSender()))
        messagesCollectionView.insertSections([listOfMessages.count - 1])
        messagesCollectionView.scrollToBottom()
        botResponse(text: text)
        inputBar.inputTextView.text = String()
    }
    
    func botResponse(text: String) {
        if (text.contains("Hi")){
            listOfMessages.append(Message(messageId: String(listOfMessages.count), sentDate: Date(), kind: .text("Hello, I am CS Ambassador. How may I help you?"), sender: bot))
            messagesCollectionView.insertSections([listOfMessages.count - 1])
            messagesCollectionView.scrollToBottom()
        }
        else if (text.contains("Score")){
            listOfMessages.append(Message(messageId: String(listOfMessages.count), sentDate: Date(), kind: .text("The admission score (Best 5) of BEng Programme in 2020 is:" + "\n" + " 26 (Upper Quartile)" + "\n" + " 25 (Median)" + "\n" + " 23 (Lower Quartile)"), sender: bot))
            messagesCollectionView.insertSections([listOfMessages.count - 1])
            messagesCollectionView.scrollToBottom()
        }
        else {
            listOfMessages.append(Message(messageId: String(listOfMessages.count), sentDate: Date(), kind: .text("Please visit the homepage of the Department of Computer Science."), sender: bot))
            messagesCollectionView.insertSections([listOfMessages.count - 1])
            messagesCollectionView.scrollToBottom()
        }
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return chatInputAccessoryView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
}
