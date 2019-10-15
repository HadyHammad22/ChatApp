//
//  ViewController.swift
//  ChatApp
//
//  Created by Hady Hammad on 9/11/19.
//  Copyright © 2019 Hady Hammad. All rights reserved.
//

import UIKit
import Firebase
class MessagesVC: UITableViewController{
    
    var messagesDictionary = [String:Any]()
    var messages = [Message]()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "LogOut", style: .plain, target: self, action: #selector(handleLogOut))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "edit"), style: .plain, target: self, action: #selector(handleNewMessages))
        tableView.register(UserCell.self, forCellReuseIdentifier: CELL_ID)
        checkIfUserIsLoggedIn()
        tableView.allowsMultipleSelectionDuringEditing = true
    }
    
    func observeUserMessages(){
        guard let uid = Auth.auth().currentUser?.uid else{return}
        DataServices.db.REF_USER_MESSAGES.child(uid).observe(.childAdded, with: { (snapshot)in
            DataServices.db.REF_USER_MESSAGES.child(uid).child(snapshot.key).observe(.childAdded, with: { (snapshot)in
                DataServices.db.REF_MESSAGES.child(snapshot.key).observe(.value, with: { (snapshot)in
                    if let dict = snapshot.value as? Dictionary<String,Any>{
                        let msg = Message(msg: dict)
                        if let id = msg.partnerID(){
                            self.messagesDictionary[id] = msg
                        }
                        self.attemptReloadOfTable()
                    }
                })
            })
        })
        
        DataServices.db.REF_USER_MESSAGES.child(uid).observe(.childRemoved, with: { (snapshot) in
            self.messagesDictionary.removeValue(forKey: snapshot.key)
            self.attemptReloadOfTable()
        })
        
    }
    
    var timer:Timer?
    private func attemptReloadOfTable(){
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
    }
    
    @objc func handleReloadTable(){
        self.messages = Array(self.messagesDictionary.values) as! [Message]
        self.messages = self.messages.sorted(by: { $0.time!.intValue > $1.time!.intValue })
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as! UserCell
        let msg = self.messages[indexPath.row]
        cell.message = msg
        if let time = msg.time?.doubleValue{
            let timestampDate = NSDate(timeIntervalSince1970: time)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm:ss a"
            cell.timeLabel.text = dateFormatter.string(from: timestampDate as Date)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let uid = Auth.auth().currentUser?.uid else{return}
        let message = self.messages[indexPath.row]
        if let partnerID = message.partnerID(){
            DataServices.db.REF_USER_MESSAGES.child(uid).child(partnerID).removeValue(completionBlock: { (err,ref) in
                if err != nil{
                    print("Failed to delete messages",err!)
                }
                self.messagesDictionary.removeValue(forKey: partnerID)
                self.attemptReloadOfTable()
            })
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let msg = self.messages[indexPath.row]
        guard let chatPartner = msg.partnerID() else{return}
        DataServices.db.getUserUsingId(id: chatPartner, completion: { user in
            self.showChat(user: user)
        })
    }
    func checkIfUserIsLoggedIn(){
        if Auth.auth().currentUser?.uid == nil{
            handleLogOut()
        }else{
            fetchUserAndSetupNavBarTitle()
        }
    }
    
    func fetchUserAndSetupNavBarTitle(){
        DataServices.db.REF_CURRENT_USERS.observeSingleEvent(of: .value, with: { (snapshot)in
            if let dict = snapshot.value as? Dictionary<String,Any>{
                let user = User(user: dict, id: snapshot.key)
                self.setupNavBarWithUser(user: user)
            }
        })
    }
    
    func setupNavBarWithUser(user: User){
        messages.removeAll()
        messagesDictionary.removeAll()
        tableView.reloadData()
        observeUserMessages()
        
        let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        
        let conatinerView = UIView()
        conatinerView.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(conatinerView)
        
        let profileImageView = UIImageView()
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        if let profileImageUrl = user.imgUrl{
            profileImageView.downloadImageUsingCache(imgUrl: profileImageUrl)
        }
        conatinerView.addSubview(profileImageView)
        //Need X, Y, Width, Height Constrains
        profileImageView.leftAnchor.constraint(equalTo: conatinerView.leftAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: conatinerView.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let nameLabel = UILabel()
        nameLabel.text = user.name!
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        conatinerView.addSubview(nameLabel)
        //Need X, Y, Width, Height Constrains
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: conatinerView.rightAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
        
        conatinerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        conatinerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        
        titleView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        titleView.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        
        self.navigationItem.titleView = titleView
    }
    @objc func handleNewMessages(){
        let newMessageVC = NewMessagesVC()
        newMessageVC.delegate = self
        let nav = UINavigationController(rootViewController: newMessageVC)
        present(nav, animated: true, completion: nil)
    }
    
    @objc func handleLogOut(){
        do{
            try Auth.auth().signOut()
        }catch let error{
            print(error)
        }
        let loginVC = LoginVC()
        loginVC.messagesController = self
        present(loginVC, animated: true, completion: nil)
    }
    
    func showChat(user: User){
        let chatCollection = chatLogVC(collectionViewLayout: UICollectionViewFlowLayout())
        chatCollection.user = user
        navigationController?.pushViewController(chatCollection, animated: true)
    }
    
}

