//
//  ViewController.swift
//  ChatApp
//
//  Created by Hady Hammad on 9/11/19.
//  Copyright © 2019 Hady Hammad. All rights reserved.
//

import UIKit

class ViewController: UITableViewController{

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "LogOut", style: .plain, target: self, action: #selector(handleLogOut))
    }
    
    @objc func handleLogOut(){
        print("LogOut")
    }

}

