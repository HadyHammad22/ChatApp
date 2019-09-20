//
//  ImageView.swift
//  ChatApp
//
//  Created by Hady Hammad on 9/13/19.
//  Copyright © 2019 Hady Hammad. All rights reserved.
//

import Foundation
import UIKit
import Firebase
let imageCache:NSCache<NSString, UIImage> = NSCache()
extension UIImageView{
    func downloadImageUsingCache(imgUrl:String){
        if let img = imageCache.object(forKey: imgUrl as NSString){
            self.image = img as UIImage
            return
        }
        
        let ref = Storage.storage().reference(forURL: imgUrl)
        ref.getData(maxSize: 2 * 1024 * 1024, completion: { (data,error) in
            if error != nil{
                print("JESS: Unable To Download Image From Firebase Storage")
            }else{
                print("JESS: Image Downloaded Successfully From Firebase Storage")
                if let imgData = data{
                    if let img = UIImage(data: imgData){
                        DispatchQueue.main.async {
                            self.image = img
                            imageCache.setObject(img, forKey: imgUrl as NSString)
                        }
                    }
                }
            }
        })
    }
}
