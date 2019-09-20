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
    let _REF_USER_IMAGES = STORAGE_BASE.child("user-pics")
    
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
    
    var REF_USER_IMAGES:StorageReference{
        return _REF_USER_IMAGES
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
    
    func sendMessgaeToFirebase(msg: String, id: String, completeion: (_ result:Bool)->()){
        guard let fromId = Auth.auth().currentUser?.uid else{return}
        let timestamp = Int(NSDate().timeIntervalSince1970)
        let dict = ["text":msg, "toId":id, "fromId":fromId,"timeStamp":timestamp] as [String : Any]
        let childRef = REF_MESSAGES.childByAutoId()
        childRef.updateChildValues(dict, withCompletionBlock: { (error, ref) in
            if error != nil{
                print(error!)
                return
            }
            let receiptionUserMessagesRef = self.REF_USER_MESSAGES.child(id)
            let msgID = childRef.key
            receiptionUserMessagesRef.updateChildValues([msgID!: true])
            
            let userMessagesRef = self.REF_USER_MESSAGES.child(fromId)
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
