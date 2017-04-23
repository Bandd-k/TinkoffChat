//
//  UserData.swift
//  TinkoffChat
//
//  Created by Denis Karpenko on 21.04.17.
//  Copyright © 2017 Denis Karpenko. All rights reserved.
//

import Foundation

import UIKit

class UserData:NSObject,NSCoding{
    var name: String?
    var image: UIImage?
    var about: String
    var color: UIColor
    init(name:String?, image:UIImage?, about:String, color:UIColor) {
        self.name = name
        self.image = image
        self.about = about
        self.color = color
    }
    
    required init(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as? String
        image = aDecoder.decodeObject(forKey: "image") as? UIImage
        about = aDecoder.decodeObject(forKey: "about") as! String
        color = aDecoder.decodeObject(forKey: "color") as! UIColor
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(image, forKey: "image")
        aCoder.encode(about, forKey: "about")
        aCoder.encode(color, forKey: "color")
    }
    
}
