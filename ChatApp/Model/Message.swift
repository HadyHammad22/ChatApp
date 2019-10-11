//
//  Message.swift
//  ChatApp
//
//  Created by Hady Hammad on 9/15/19.
//  Copyright © 2019 Hady Hammad. All rights reserved.
//

import UIKit
import Firebase
class Message{
    var text:String?
    var fromId:String?
    var toId:String?
    var time:NSNumber?
    var imageUrl:String?
    var imageWidth:NSNumber?
    var imageHieght:NSNumber?
    
    init(msg: Dictionary<String,Any>) {
        self.text = msg["text"] as? String
        self.imageUrl = msg["imageUrl"] as? String
        self.fromId = msg["fromId"] as? String
        self.toId = msg["toId"] as? String
        self.time = msg["timeStamp"] as? NSNumber
        self.imageWidth = msg["imageWidth"] as? NSNumber
        self.imageHieght = msg["imageHieght"] as? NSNumber
    }
    
    func partnerID() -> String?{
        return fromId == Auth.auth().currentUser!.uid ? toId : fromId
    }
}
