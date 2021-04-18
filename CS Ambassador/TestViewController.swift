//
//  TestViewController.swift
//  CS Ambassador
//
//  Created by Winnie Yip on 18/4/2021.
//

import UIKit


class TestViewController: UIViewController, ChatInputAccessoryViewDelegate, UITableViewDelegate, UITableViewDataSource, ButtonViewClick, CardButtonViewClick {
    
    private var listOfMessages: [Msg] = []
    
    private lazy var chatInputAccessoryView: ChatInputAccessoryView = {
        let view = ChatInputAccessoryView()
        view.frame = .init(x: 0, y: 0, width: view.frame.width, height: 35)
        view.delegate = self
        return view
    }()
    
    @IBOutlet weak var testTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testTableView.backgroundColor = .white
        testTableView.delegate = self
        testTableView.dataSource = self
        testTableView.register(UINib(nibName: "ChatbotTableViewCell", bundle: nil), forCellReuseIdentifier: ChatbotTableViewCell.identifier)
        testTableView.register(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: UserCell.identifier)
        testTableView.register(UINib(nibName: "ButtonCell", bundle: nil), forCellReuseIdentifier: ButtonCell.identifier)
        testTableView.register(UINib(nibName: "CardInfoCell", bundle: nil), forCellReuseIdentifier: CardInfoCell.identifier)
        testTableView.register(UINib(nibName: "CardButtonCell", bundle: nil), forCellReuseIdentifier: CardButtonCell.identifier)
        
        getApi(text: "aptitude_test")
    }
    
    func clickOnSendButton(text: String) {
        listOfMessages.append(Msg(message: text, sender: "user", type: "", value: ""))
        testTableView.reloadData()
        getApi(text: text)
    }
    
    func getApi(text: String) {
        //api
        let deviceID = UIDevice.current.identifierForVendor?.uuidString
        print(deviceID ?? "tester")
        let json: [String: Any] = ["session_id": deviceID ?? "tester", "text": text]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        let url = URL(string: "https://cs-ambassador.herokuapp.com/webhook")!
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
                            self.testTableView.reloadData()
                            print("count: \(self.listOfMessages.count)")
                            //self.chatbotTableView.scrollToRow(at: IndexPath(row: self.listOfMessages.count-1, section: 0), at: .bottom, animated: true)
                            let indexPath = IndexPath(row: self.listOfMessages.count-1, section: 0)
                            if let _ = self.testTableView.cellForRow(at: indexPath) {
                                self.testTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                            }
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
                            self.testTableView.reloadData()
                            print("count2: \(self.listOfMessages.count)")
                            //self.chatbotTableView.scrollToRow(at: IndexPath(row: self.listOfMessages.count-1, section: 0), at: .bottom, animated: true)
                            let indexPath = IndexPath(row: self.listOfMessages.count-1, section: 0)
                            if let _ = self.testTableView.cellForRow(at: indexPath) {
                                self.testTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                            }
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
                            self.testTableView.reloadData()
                            //self.chatbotTableView.scrollToRow(at: IndexPath(row: self.listOfMessages.count-i-1, section: 0), at: .top, animated: true)
                            let indexPath = IndexPath(row: self.listOfMessages.count-i-1, section: 0)
                            if let _ = self.testTableView.cellForRow(at: indexPath) {
                                self.testTableView.scrollToRow(at: indexPath, at: .top, animated: true)
                            }
                        }
                    }
                }
            }
        }
        task.resume()
        
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
        testTableView.estimatedRowHeight = 20
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if listOfMessages[indexPath.row].sender == "user" {
            let cell = testTableView.dequeueReusableCell(withIdentifier: UserCell.identifier, for: indexPath) as! UserCell
            cell.messageText = " "+listOfMessages[indexPath.row].message

            return cell
        }
        else if listOfMessages[indexPath.row].sender == "button" {
            let cell = testTableView.dequeueReusableCell(withIdentifier: ButtonCell.identifier, for: indexPath) as! ButtonCell
            cell.buttonView.setTitle("  "+listOfMessages[indexPath.row].message+"  ", for: .normal)
            cell.isUserInteractionEnabled = true
            cell.cellDelegate = self
            cell.index = indexPath

            return cell
        }
        else if listOfMessages[indexPath.row].sender == "cardInfo" {
            let cell = testTableView.dequeueReusableCell(withIdentifier: CardInfoCell.identifier, for: indexPath) as! CardInfoCell
            
            if let url = URL(string:listOfMessages[indexPath.row].value){
                let data = try? Data(contentsOf: url)
                cell.cardImageView.image = UIImage(data: data!)
            }
            
            cell.cardTitleView.text = listOfMessages[indexPath.row].message
            cell.cardSubView.text = listOfMessages[indexPath.row].type
            
            return cell
        }
        else if listOfMessages[indexPath.row].sender == "cardButton" {
            let cell = testTableView.dequeueReusableCell(withIdentifier: CardButtonCell.identifier, for: indexPath) as! CardButtonCell
            
            cell.cardButtonView.setTitle(listOfMessages[indexPath.row].message, for: .normal)
            cell.isUserInteractionEnabled = true
            cell.cellDelegate = self
            cell.index = indexPath

            return cell
        }
        
        let cell = testTableView.dequeueReusableCell(withIdentifier: ChatbotTableViewCell.identifier, for: indexPath) as! ChatbotTableViewCell
        //cell.messageTextView.text = listOfMessages[indexPath.row].message
        cell.messageText = " "+listOfMessages[indexPath.row].message
        //cell.messageText?.message = listOfMessages[indexPath.row].message
        
        return cell
    }

    func onClickButton(index: Int) {
        print("\(listOfMessages[index].message), \(listOfMessages[index].type), \(listOfMessages[index].value) click")
        let text = listOfMessages[index].message
        listOfMessages.append(Msg(message: text, sender: "user", type: "", value: ""))
        testTableView.reloadData()
        
        if listOfMessages[index].type == "payload" {
            let value = listOfMessages[index].value
            getApi(text: value)
        }
        else if listOfMessages[index].type == "web_url" {
            let urlComponents = URLComponents (string: listOfMessages[index].value)!
            UIApplication.shared.open (urlComponents.url!)
        }
        
        testTableView.reloadData()
        testTableView.scrollToRow(at: IndexPath(row: self.listOfMessages.count-1, section: 0), at: .bottom, animated: true)
    }
    
    func onClickCardButton(index: Int) {
        print("\(listOfMessages[index].message), \(listOfMessages[index].type), \(listOfMessages[index].value) click")//
        let text = listOfMessages[index].message
        listOfMessages.append(Msg(message: text, sender: "user", type: "", value: ""))
        testTableView.reloadData()
        
        if listOfMessages[index].type == "payload" {
            let value = listOfMessages[index].value
            getApi(text: value)
        }
        else if listOfMessages[index].type == "web_url" {
            let urlComponents = URLComponents (string: listOfMessages[index].value)!
            UIApplication.shared.open (urlComponents.url!)
        }
        
        testTableView.reloadData()
        testTableView.scrollToRow(at: IndexPath(row: self.listOfMessages.count-1, section: 0), at: .bottom, animated: true)
    }
    
}
