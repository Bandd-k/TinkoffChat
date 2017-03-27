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
}
