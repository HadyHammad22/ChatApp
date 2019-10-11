//
//  chatLogVC.swift
//  ChatApp
//
//  Created by Hady Hammad on 9/15/19.
//  Copyright © 2019 Hady Hammad. All rights reserved.
//

import UIKit
import Firebase
class chatLogVC: UICollectionViewController, UITextFieldDelegate,UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    lazy var inputTextField:UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter message..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()
    
    var user:User?{
        didSet{
            self.navigationItem.title = user?.name
            observeMessages()
        }
    }
    
    var messages = [Message]()
    func observeMessages(){
        guard let id = Auth.auth().currentUser?.uid, let toId = user?.id else{return}
        DataServices.db.REF_USER_MESSAGES.child(id).child(toId).observe(.childAdded, with: { (snapshot) in
            DataServices.db.REF_MESSAGES.child(snapshot.key).observe(.value, with: { (snapshot) in
                if let dict = snapshot.value as? Dictionary<String,Any>{
                    let msg = Message(msg: dict)
                    self.messages.append(msg)
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                        let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                        self.collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
                    }
                }
            })
        })
    }
    
    var containerViewBottomAnchor:NSLayoutConstraint!
    
    lazy var inputContainerView:UIView = {
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        containerView.backgroundColor = UIColor.white
        let uploadImage = UIImageView()
        uploadImage.image = UIImage(named: "add_image")
        uploadImage.isUserInteractionEnabled = true
        uploadImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSendImage)))
        uploadImage.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(uploadImage)
        
        //constrains
        uploadImage.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 4).isActive = true
        uploadImage.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        uploadImage.heightAnchor.constraint(equalToConstant: 44).isActive = true
        uploadImage.widthAnchor.constraint(equalToConstant: 44).isActive = true
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        containerView.addSubview(sendButton)
        
        //constrains
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        containerView.addSubview(self.inputTextField)
        
        //constrains
        self.inputTextField.leftAnchor.constraint(equalTo: uploadImage.rightAnchor, constant: 8).isActive = true
        self.inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        self.inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        self.inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        let seperatorView = UIView()
        seperatorView.backgroundColor = SEPERATOR_VIEW_COLOR
        seperatorView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(seperatorView)
        
        //constrains
        seperatorView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        seperatorView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        seperatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        seperatorView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        
        return containerView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = UIColor.white
        collectionView.register(ChatMessageCell.self, forCellWithReuseIdentifier: CELL_ID)
        collectionView.keyboardDismissMode = .interactive
        setupKeyboardObserves()
    }
    
    func setupKeyboardObserves(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    
    @objc func handleKeyboardDidShow(){
        if messages.count > 0{
            let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: .top, animated: true)
        }
    }
    
    @objc func handleSendImage(){
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            uploadImageToFirebase(image: image)
        }else{
            print("JESS: A Valid Image Wasn't Selected")
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func uploadImageToFirebase(image: UIImage){
        if let imgData = image.jpegData(compressionQuality: 0.2){
            let imgUid = NSUUID().uuidString
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpeg"
            
            DataServices.db.REF_MESSAGES_IMAGES.child(imgUid).putData(imgData, metadata: metaData, completion: { (metadata,error) in
                if error != nil{
                    print("JESS: unable To Upload Image To Firebase Storage")
                    return
                }else{
                    print("JESS: Upload Image To Firebase Storage Successfully")
                    DataServices.db.REF_MESSAGES_IMAGES.child(imgUid).downloadURL(completion: { (url, error) in
                        if let imageUrl = url?.absoluteString{
                            self.sendMessagesWithImage(imageUrl: imageUrl, image: image)
                        }
                    })
                }
            })
            
        }
    }
    
    private func sendMessagesWithImage(imageUrl: String, image: UIImage){
        let dict = [ "imageUrl": imageUrl, "imageWidth": image.size.width, "imageHieght": image.size.height] as [String : Any]
        DataServices.db.sendMessgaeToFirebase(toId: self.user!.id!, properities: dict, completeion: { result in
            if result{
                print("Messgae Send Successfully")
            }
        })
    }
    
    override var inputAccessoryView: UIView?{
        get{
            return inputContainerView
        }
    }
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_ID, for: indexPath) as! ChatMessageCell
        let msg = self.messages[indexPath.row]
        setupCell(cell: cell, message: msg)
        cell.textView.text = msg.text
        if let text = msg.text{
            cell.containerWidthAnchor?.constant = estimateFrameForText(text: text).width + 32
        }else if msg.imageUrl != nil{
            cell.containerWidthAnchor?.constant = 200
        }
        return cell
    }
    
    private func setupCell(cell: ChatMessageCell, message: Message){
        if let profileImageUrl = self.user?.imgUrl{
            cell.profileImage.downloadImageUsingCache(imgUrl: profileImageUrl)
        }
        
        if message.fromId == Auth.auth().currentUser?.uid{
            cell.containerView.backgroundColor = CHAT_COLOR
            cell.textView.textColor = UIColor.white
            cell.profileImage.isHidden = true
            cell.containerRightAnchor?.isActive = true
            cell.containerLeftAnchor?.isActive = false
        }else{
            cell.containerView.backgroundColor = CHAT_GRAY_COLOR
            cell.textView.textColor = UIColor.black
            cell.profileImage.isHidden = false
            cell.containerRightAnchor?.isActive = false
            cell.containerLeftAnchor?.isActive = true
            
        }
        
        if let imageUrl = message.imageUrl{
            cell.messageImage.downloadImageUsingCache(imgUrl: imageUrl)
            cell.messageImage.isHidden = false
            cell.containerView.backgroundColor = UIColor.clear
        }else{
            cell.messageImage.isHidden = true
        }
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height:CGFloat = 80
        let message = self.messages[indexPath.row]
        if let text = message.text{
            height = estimateFrameForText(text: text).height + 20
        }else if let imageWidth = message.imageWidth?.floatValue, let imageHieght = message.imageHieght?.floatValue{
            height = CGFloat(imageHieght / imageWidth * 200)
        }
        return CGSize(width: UIScreen.main.bounds.width, height: height)
    }
    
    private func estimateFrameForText(text:String) -> CGRect{
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    @objc func handleSend(){
        DataServices.db.sendMessgaeToFirebase(toId: user!.id!, properities: ["text":inputTextField.text!] ,completeion: { result in
            if result{
                self.inputTextField.text = nil
                print("Messgae Send Successfully")
            }
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
    
}
