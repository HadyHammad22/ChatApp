//
//  String.swift
//  ChatApp
//
//  Created by Hady Hammad on 10/16/19.
//  Copyright © 2019 Hady Hammad. All rights reserved.
//

import UIKit
extension String{
    func estimateFrameForText() -> CGRect{
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: self).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
}
