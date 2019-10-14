//
//  DataServices.swift
//  ChatApp
//
//  Created by Hady Hammad on 9/11/19.
//  Copyright © 2019 Hady Hammad. All rights reserved.
//

import Foundation
import UIKit
import Firebase

let DB_BASE = Database.database().reference()
let STORAGE_BASE = Storage.storage().reference()

class DataServices{
    static let db = DataServices()
    
    //DB_references
    let _REF_BASE = DB_BASE
    let _REF_USERS = DB_BASE.child("users")
    let _REF_MESSAGES = DB_BASE.child("messgaes")
    let _REF_USER_MESSAGES = DB_BASE.child("user_messgaes")
    //Storage_references
    let _REF_VIDEOS = STORAGE_BASE.child("message-videos")
    let _REF_USER_IMAGES = STORAGE_BASE.child("user-pics")
    let _REF_MESSAGES_IMAGES = STORAGE_BASE.child("message-images")
    
    var REF_BASE:DatabaseReference{
        return _REF_BASE
    }
    
    var REF_USERS:DatabaseReference{
        return _REF_USERS
    }
    
    var REF_MESSAGES:DatabaseReference{
        return _REF_MESSAGES
    }
    
    var REF_USER_MESSAGES:DatabaseReference{
        return _REF_USER_MESSAGES
    }
    
    var REF_VIDEOS:StorageReference{
        return _REF_VIDEOS
    }
    
    var REF_USER_IMAGES:StorageReference{
        return _REF_USER_IMAGES
    }
    
    var REF_MESSAGES_IMAGES:StorageReference{
        return _REF_MESSAGES_IMAGES
    }

    
    var REF_CURRENT_USERS:DatabaseReference{
        let uid = Auth.auth().currentUser?.uid 
        let user = REF_USERS.child(uid!)
        return user
    }
    
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String,String>, completeion: (_ result:Bool)->()){
        REF_USERS.child(uid).updateChildValues(userData)
        completeion(true)
    }
    
    func sendMessgaeToFirebase(toId: String, properties: [String:Any], completeion: (_ result:Bool)->()){
        guard let fromId = Auth.auth().currentUser?.uid else{return}
        let timestamp = Int(NSDate().timeIntervalSince1970)
        var dict:[String : Any] = ["toId":toId, "fromId":fromId,"timeStamp":timestamp]
        properties.forEach({dict[$0] = $1})
        let childRef = REF_MESSAGES.childByAutoId()
        childRef.updateChildValues(dict, withCompletionBlock: { (error, ref) in
            if error != nil{
                print(error!)
                return
            }
            let receiptionUserMessagesRef = self.REF_USER_MESSAGES.child(toId).child(fromId)
            let msgID = childRef.key
            receiptionUserMessagesRef.updateChildValues([msgID!: true])
            
            let userMessagesRef = self.REF_USER_MESSAGES.child(fromId).child(toId)
            userMessagesRef.updateChildValues([msgID!: true])
        })
        completeion(true)
    }
    
    func getUserUsingId(id: String, completion: @escaping (_ user:User)->()){
        REF_USERS.child(id).observe(.value, with: { (snapshot) in
            if let dict = snapshot.value as? Dictionary<String,Any>{
                let user = User(user: dict, id: snapshot.key)
                completion(user)
            }
        })
    }
}
