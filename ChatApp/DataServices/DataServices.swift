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
class DataServices{
    static let db = DataServices()
    
    //DB_references
    let _REF_BASE = DB_BASE
    let _REF_USERS = DB_BASE.child("users")
    
    var REF_BASE:DatabaseReference{
        return _REF_BASE
    }
    
    var REF_USERS:DatabaseReference{
        return _REF_USERS
    }
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String,String>, completeion: (_ result:Bool)->()){
        REF_USERS.child(uid).updateChildValues(userData)
        completeion(true)
    }
}
