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
        chatbotTableView.register(UINib(nibName: "ButtonCell", bundle: nil), forCellReuseIdentifier: ButtonCell.identifier)
        //chatbotTableView.register(UINib(nibName: "CardCell", bundle: nil), forCellReuseIdentifier: CardCell.identifier)
        chatbotTableView.register(UINib(nibName: "CardInfoCell", bundle: nil), forCellReuseIdentifier: CardInfoCell.identifier)
        chatbotTableView.register(UINib(nibName: "CardButtonCell", bundle: nil), forCellReuseIdentifier: CardButtonCell.identifier)
    }
    
    func clickOnSendButton(text: String) {
        listOfMessages.append(Msg(message: text, sender: "user", type: "", value: ""))
        chatbotTableView.reloadData()
        
        //api
        let json: [String: Any] = ["session_id": "tester", "text": text]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        let url = URL(string: "http://cs-chatbot.eastasia.cloudapp.azure.com:5001/webhook")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.httpBody = jsonData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any],
               let messageArray = responseJSON["messages"] as? [[String: Any]]{
                print(responseJSON)
                for m in messageArray{
                    let mType = m["type"] as! String
                    print(mType)
                    if mType == "text" {
                        print("yea here text")
                        let mText = m["text"] as! String
                        print(mText.replacingOccurrences(of: "<br>", with: "\n"))
                        self.listOfMessages.append(Msg(message: mText.replacingOccurrences(of: "<br>", with: "\n"), sender: "bot", type: "", value: ""))
                        DispatchQueue.main.async {
                            self.chatbotTableView.reloadData()
                            self.chatbotTableView.scrollToRow(at: IndexPath(row: self.listOfMessages.count-1, section: 0), at: .bottom, animated: true)
                        }
                    }
                    else if mType == "quick_replies" {
                        print("yea here quick replies")
                        let mText = m["text"] as! String
                        print(mText.replacingOccurrences(of: "<br>", with: "\n"))
                        self.listOfMessages.append(Msg(message: mText.replacingOccurrences(of: "<br>", with: "\n"), sender: "bot", type: "", value: ""))
                        let mButtons = m["buttons"] as! [[String: Any]]
                        for b in mButtons{
                            let bTitle = b["title"] as! String
                            let bType = b["type"] as! String
                            let bValue = b["value"] as! String
                            print(bTitle)
                            self.listOfMessages.append(Msg(message: bTitle, sender: "button", type: bType, value: bValue))
                        }
                        DispatchQueue.main.async {
                            self.chatbotTableView.reloadData()
                            self.chatbotTableView.scrollToRow(at: IndexPath(row: self.listOfMessages.count-1, section: 0), at: .bottom, animated: true)
                        }
                    }
                    else if mType == "cards" {
                        print("yea here cards")
                        let mCards = m["cards"] as! [[String: Any]]
                        var i = mCards.count
                        for c in mCards{
                            let cTitle = c["title"] as! String
                            let cSubtitle = c["subtitle"] as! String
                            let cImage = c["image_url"] as! String
                            self.listOfMessages.append(Msg(message: cTitle.replacingOccurrences(of: "<br>", with: "\n"), sender: "cardInfo", type: cSubtitle.replacingOccurrences(of: "<br>", with: "\n"), value: cImage))
                            let cButtons = c["buttons"] as! [[String: Any]]
                            i = i + cButtons.count
                            for b in cButtons{
                                let bTitle = b["title"] as! String
                                let bType = b["type"] as! String
                                let bValue = b["value"] as! String
                                print(bTitle)
                                self.listOfMessages.append(Msg(message: bTitle, sender: "cardButton", type: bType, value: bValue))
                            }
                        }
                        DispatchQueue.main.async {
                            self.chatbotTableView.reloadData()
                            self.chatbotTableView.scrollToRow(at: IndexPath(row: self.listOfMessages.count-i-1, section: 0), at: .top, animated: true)
                        }
                    }
                }
            }
        }
        task.resume()
        

        /*if text == "Hi" {
            listOfMessages.append(Msg(message: "Hey", sender: "bot", type: "", value: ""))
            chatbotTableView.reloadData()
        }
        else if text == "Hii"{
            listOfMessages.append(Msg(message: "Heyy", sender: "button", type: "", value: ""))
            chatbotTableView.reloadData()
        }
        else if text == "Hiii"{
            listOfMessages.append(Msg(message: "Heyyy", sender: "card", type: "", value: ""))
            listOfMessages.append(Msg(message: "Heyyyy", sender: "cardButton", type: "", value: ""))
            chatbotTableView.reloadData()
        }
        
        chatbotTableView.scrollToRow(at: IndexPath(row: listOfMessages.count-1, section: 0), at: .bottom, animated: true)
        */
        
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
            cell.messageText = " "+listOfMessages[indexPath.row].message

            return cell
        }
        else if listOfMessages[indexPath.row].sender == "button" {
            let cell = chatbotTableView.dequeueReusableCell(withIdentifier: ButtonCell.identifier, for: indexPath) as! ButtonCell
            cell.buttonView.setTitle("  "+listOfMessages[indexPath.row].message+"  ", for: .normal)

            return cell
        }
        else if listOfMessages[indexPath.row].sender == "cardInfo" {
            /*let cell = chatbotTableView.dequeueReusableCell(withIdentifier: CardCell.identifier, for: indexPath) as! CardCell
            
            let url = URL(string: "https://coconuts.co/wp-content/uploads/2019/05/HKU-main-bldg-google-maps-960x540.jpg")
            let data = try? Data(contentsOf: url!)
            cell.imageView!.image = UIImage(data: data!)
            
            cell.cardTitleView.text = "title"
            cell.cardSubView.text = "description"
            cell.cardButtonView.setTitle("button", for: .normal)
            let listOfButtons: [UIButton] = [cell.cardButtonView, cell.cardButtonView2]
            listOfButtons[1].setTitle("button2", for: .normal)
            listOfButtons[1].isHidden = false
            cell.cardHeightConstraint.constant = 500
            cell.layoutIfNeeded()

            return cell*/
            let cell = chatbotTableView.dequeueReusableCell(withIdentifier: CardInfoCell.identifier, for: indexPath) as! CardInfoCell
            
            let url = URL(string:listOfMessages[indexPath.row].value)
            let data = try? Data(contentsOf: url!)
            cell.cardImageView.image = UIImage(data: data!)
            
            cell.cardTitleView.text = listOfMessages[indexPath.row].message
            cell.cardSubView.text = listOfMessages[indexPath.row].type
            
            return cell
        }
        else if listOfMessages[indexPath.row].sender == "cardButton" {
            let cell = chatbotTableView.dequeueReusableCell(withIdentifier: CardButtonCell.identifier, for: indexPath) as! CardButtonCell
            
            cell.cardButtonView.setTitle(listOfMessages[indexPath.row].message, for: .normal)

            return cell
        }
        
        let cell = chatbotTableView.dequeueReusableCell(withIdentifier: ChatbotTableViewCell.identifier, for: indexPath) as! ChatbotTableViewCell
        //cell.messageTextView.text = listOfMessages[indexPath.row].message
        cell.messageText = " "+listOfMessages[indexPath.row].message
        //cell.messageText?.message = listOfMessages[indexPath.row].message
        
        return cell
    }
}


