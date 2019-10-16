//
//  ChatInputContainerView.swift
//  ChatApp
//
//  Created by Hady Hammad on 10/15/19.
//  Copyright © 2019 Hady Hammad. All rights reserved.
//

import UIKit
class ChatInputContainerView:UIView,UITextFieldDelegate{
    
    var chatLogController:ChatLogVC? {
        didSet{
          sendButton.addTarget(chatLogController, action: #selector(ChatLogVC.handleSend), for: .touchUpInside)
          uploadImage.addGestureRecognizer(UITapGestureRecognizer(target: chatLogController, action: #selector(ChatLogVC.handleSendImage)))
        }
    }
    
    lazy var inputTextField:UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter message..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()
    
    var sendButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Send", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    var uploadImage:UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "add_image")
        iv.isUserInteractionEnabled = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    var seperatorView:UIView = {
        let view = UIView()
        view.backgroundColor = SEPERATOR_VIEW_COLOR
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        addSubview(uploadImage)
        //constrains
        uploadImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 4).isActive = true
        uploadImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        uploadImage.heightAnchor.constraint(equalToConstant: 40).isActive = true
        uploadImage.widthAnchor.constraint(equalToConstant: 35).isActive = true
        
        addSubview(sendButton)
        //constrains
        sendButton.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        sendButton.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        addSubview(self.inputTextField)
        //constrains
        self.inputTextField.leftAnchor.constraint(equalTo: uploadImage.rightAnchor, constant: 8).isActive = true
        self.inputTextField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        self.inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        self.inputTextField.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
       
        addSubview(seperatorView)
        //constrains
        seperatorView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        seperatorView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        seperatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        seperatorView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        chatLogController?.handleSend()
        return true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
