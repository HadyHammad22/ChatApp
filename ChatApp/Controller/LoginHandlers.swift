//
//  LoginHandlers.swift
//  ChatApp
//
//  Created by Hady Hammad on 9/13/19.
//  Copyright © 2019 Hady Hammad. All rights reserved.
//

import Foundation
import UIKit
extension LoginVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    @objc func handleSelectProfileImage(){
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            profileImageView.image = image
            self.selectedImage = true
        }else{
            print("JESS: A Valid Image Wasn't Selected")
        }
        dismiss(animated: true, completion: nil)
    }
}
