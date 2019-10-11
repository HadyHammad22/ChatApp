//
//  chatCell.swift
//  ChatApp
//
//  Created by Hady Hammad on 9/17/19.
//  Copyright © 2019 Hady Hammad. All rights reserved.
//

import UIKit

class ChatMessageCell: UICollectionViewCell {
    
    let textView:UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.backgroundColor = UIColor.clear
        return tv
    }()
    
    let containerView:UIView = {
        let cv = UIView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.layer.cornerRadius = 16
        cv.layer.masksToBounds = true
        return cv
    }()
    
    let profileImage:UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "profileDefault")
        iv.layer.cornerRadius = 16
        iv.layer.masksToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let messageImage:UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 16
        iv.layer.masksToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    var containerWidthAnchor:NSLayoutConstraint?
    var containerRightAnchor:NSLayoutConstraint?
    var containerLeftAnchor:NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(containerView)
        addSubview(textView)
        addSubview(profileImage)
        containerView.addSubview(messageImage)
        
        //Constraints x,y,w,h
        messageImage.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        messageImage.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        messageImage.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        messageImage.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        
        //Constraints x,y,w,h
        containerRightAnchor = containerView.rightAnchor.constraint(equalTo: self.rightAnchor,constant: -8)
        containerRightAnchor?.isActive = true
        
        containerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        containerLeftAnchor = containerView.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 8)
        //containerLeftAnchor?.isActive = false
        
        containerView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        containerWidthAnchor = containerView.widthAnchor.constraint(equalToConstant: 200)
        containerWidthAnchor?.isActive = true
        
        //Constraints x,y,w,h
        textView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        textView.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        //Constraints x,y,w,h
        profileImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImage.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 32).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 32).isActive = true
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }}
