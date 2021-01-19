//
//  ViewController.swift
//  CS Ambassador
//
//  Created by Winnie Yip on 10/1/2021.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet var collection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collection.delegate = self
        collection.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collection.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        if (indexPath.item == 0){
            cell.backgroundColor = UIColor(hex: 0x506497)
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: cell.bounds.size.width, height: 250))
            label.textColor = UIColor.white
            label.textAlignment = .center
            label.font = label.font.withSize(20)
            label.text = "CHATBOT"
            cell.contentView.addSubview(label)
        }
        else {
            cell.backgroundColor = UIColor(hex: 0x6383A4)
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: cell.bounds.size.width, height: 125))
            label.textColor = UIColor.white
            label.textAlignment = .center
            label.font = label.font.withSize(20)
            if (indexPath.item == 1) {
                label.text = "HKUCS HOMEPAGE"
                cell.contentView.addSubview(label)
            }
            else if (indexPath.item == 2) {
                label.text = "OTHERS"
                cell.contentView.addSubview(label)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if (indexPath.item == 0) {
            let chat = ChatViewController()
            navigationController?.pushViewController(chat, animated: true)
        }
        else if (indexPath.item == 1) {
            let urlComponents = URLComponents (string: "https://www.cs.hku.hk/")!
             UIApplication.shared.open (urlComponents.url!)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        if (indexPath.item == 0) {
            return CGSize(width: collectionView.bounds.width, height: 250)
        }
        else {
            return CGSize(width: collectionView.bounds.width, height: 125)
        }
    }
}

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "")
       assert(green >= 0 && green <= 255, "")
       assert(blue >= 0 && blue <= 255, "")
       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }
   convenience init(hex: Int) {
       self.init(
           red: (hex >> 16) & 0xFF,
           green: (hex >> 8) & 0xFF,
           blue: hex & 0xFF
       )
   }
}
