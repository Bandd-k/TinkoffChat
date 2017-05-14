//
//  RequestSender.swift
//  TinkoffChat
//
//  Created by Denis Karpenko on 14.05.17.
//  Copyright © 2017 Denis Karpenko. All rights reserved.
//

import Foundation


class RequestSender{
    let session = URLSession.shared
    func send(url: URL, completionHandler: @escaping (_ data:Data?,_ error:Error?)->()) {
        let task = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            completionHandler(data,error)
        }
        task.resume()
    }

}
