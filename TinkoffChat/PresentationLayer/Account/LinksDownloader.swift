//
//  ImageDownloader.swift
//  TinkoffChat
//
//  Created by Denis Karpenko on 14.05.17.
//  Copyright © 2017 Denis Karpenko. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
//5362134-e2d4049a6ac9debeccc51b448
class LinksDownloader{
    let apiKey:String
    let sender = RequestSender()
    init(apiKey: String){
        self.apiKey = apiKey
    }
    
    func requestImagesLinks(tag:String,closure:@escaping ([String])->()){
        let url = URL(string:"https://pixabay.com/api/?key=\(apiKey)&q=\(tag)&image_type=photo&per_page=200")!
        sender.send(url: url) { (data, error) in
            var answer = [String]()
            if let data = data{
                let json = JSON(data: data)
                let images = json["hits"]
                for (_,subJson):(String, JSON) in images {
                    answer.append(subJson["webformatURL"].stringValue)
                }
            }
            closure(answer)
        }
    }
    
    
}
