//
//  User.swift
//  ChatApp
//
//  Created by Hady Hammad on 9/12/19.
//  Copyright © 2019 Hady Hammad. All rights reserved.
//

import Foundation
import UIKit

class User{
    var id:String?
    var name:String?
    var email:String?
    var imgUrl:String?
    init(user: Dictionary<String,Any>,id: String) {
        self.id = id
        self.name = user["Name"] as! String
        self.email = user["Email"] as! String
        self.imgUrl = user["ImageUrl"] as! String
    }
}
