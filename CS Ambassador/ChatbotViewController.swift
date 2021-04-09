//
//  ChatbotViewController.swift
//  CS Ambassador
//
//  Created by Winnie Yip on 8/4/2021.
//

import UIKit

struct Msg {
    var message: String
    var sender: String
    var type: String
    var value: String
}

class ChatbotViewController: UIViewController, ChatInputAccessoryViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    //private let messageID = "messageID"
    private var listOfMessages: [Msg] = []
    
    private lazy var chatInputAccessoryView: ChatInputAccessoryView = {
        let view = ChatInputAccessoryView()
        view.frame = .init(x: 0, y: 0, width: view.frame.width, height: 35)
        view.delegate = self
        return view
    }()
    
    @IBOutlet weak var chatbotTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatbotTableView.backgroundColor = .white
        chatbotTableView.delegate = self
        chatbotTableView.dataSource = self
        //chatbotTableView.register(UITableViewCell.self, forCellReuseIdentifier: messageID)
        chatbotTableView.register(UINib(nibName: "ChatbotTableViewCell", bundle: nil), forCellReuseIdentifier: ChatbotTableViewCell.identifier)
        chatbotTableView.register(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: UserCell.identifier)
    }
    
    func clickOnSendButton(text: String) {
        listOfMessages.append(Msg(message: text, sender: "user", type: "", value: ""))
        chatbotTableView.reloadData()
        chatInputAccessoryView.inputBoxView.text = ""
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return chatInputAccessoryView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        chatbotTableView.estimatedRowHeight = 20
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if listOfMessages[indexPath.row].sender == "user" {
            let cell = chatbotTableView.dequeueReusableCell(withIdentifier: UserCell.identifier, for: indexPath) as! UserCell
            //cell.userMessageTextView.text = listOfMessages[indexPath.row].message
            cell.messageText = listOfMessages[indexPath.row].message

            return cell
            
        }
        
        let cell = chatbotTableView.dequeueReusableCell(withIdentifier: ChatbotTableViewCell.identifier, for: indexPath) as! ChatbotTableViewCell
        //cell.messageTextView.text = listOfMessages[indexPath.row].message
        cell.messageText = listOfMessages[indexPath.row].message
        //cell.messageText?.message = listOfMessages[indexPath.row].message
        
        cell.tintColor = UIColor(hex: 0xEFEEE5)
        //cell.backgroundColor = .white
        
        return cell
    }
}


