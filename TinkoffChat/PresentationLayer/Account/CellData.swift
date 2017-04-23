//
//  CellData.swift
//  TinkoffChat
//
//  Created by Denis Karpenko on 22.04.17.
//  Copyright © 2017 Denis Karpenko. All rights reserved.
//

import Foundation

struct cellData {
    init(name:String?,userID:String,message:String?,date:Date?,online:Bool,hasUnreaded:Bool) {
        self.userID = userID
        self.name = name
        self.message = message
        self.date = date
        self.online = online
        self.hasUnreadedMessages = hasUnreaded
    }
    var name: String?
    var userID: String
    var message: String?
    var date:Date?
    var online:Bool
    var hasUnreadedMessages:Bool
}
