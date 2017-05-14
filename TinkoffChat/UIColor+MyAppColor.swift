//
//  UIColor+MyAppColor.swift
//  TinkoffChat
//
//  Created by Denis Karpenko on 19.03.17.
//  Copyright © 2017 Denis Karpenko. All rights reserved.
//

import Foundation
import UIKit
extension UIColor {
    class func appColor() -> UIColor {
        return UIColor(red: 255.0/255.0, green: 206.0/255.0, blue:
            22.0/255.0, alpha: 1)
    }
}

extension String {
    
    static func random(length: Int = 5) -> String {
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""
        
        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.characters.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        return randomString
    }
    
    static func generateMessageId()-> String{
        let string = "\(arc4random_uniform(UINT32_MAX))+\(Date.timeIntervalSinceReferenceDate)+\(arc4random_uniform(UINT32_MAX))".data(using: .utf8)?.base64EncodedString()
        return string!
    }
    
    static func generateConversationId(id1:String,id2:String)->String{
        if id1>id2{
            return id1+id2;
        }
        else{
            return id2+id1;
        }
    }
}
