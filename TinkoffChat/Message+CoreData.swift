//
//  Message+CoreData.swift
//  TinkoffChat
//
//  Created by Denis Karpenko on 08.05.17.
//  Copyright © 2017 Denis Karpenko. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension Message {
    static func insertMessage(text: String,recieverId: String,senderId: String,in context:NSManagedObjectContext)->Message?{
        if let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as? Message {
            message.isUnread = true
            message.messageId = String.generateMessageId()
            message.date = Date() as NSDate?
            message.text = text
            let reciverUser = User.findOrInsertUser(with: recieverId, in: context)
            let senderUser = User.findOrInsertUser(with: senderId, in: context)
            message.reciever = reciverUser
            message.sender = senderUser
            let convId = String.generateConversationId(id1: recieverId, id2: senderId)
            let conversation = Conversation.findConversation(with:convId, in: context)
            message.conversation = conversation
            return message
        }
        return nil
    }
    
    
    
    static func findMessagesByConversation(with Id: String, in context:NSManagedObjectContext) -> [Message]?{
        guard let model = context.persistentStoreCoordinator?.managedObjectModel else {
            print ("Model is not available in context")
            assert(false)
            return nil
        }
        var messages : [Message]?
        guard let fetchRequest = Message.fetchRequestMessageByConversation(with: Id,model: model) else {
            return nil
        }
        
        do {
            messages = try context.fetch(fetchRequest)
        } catch {
            print ("Failed to fetch appUser: \(error)")
        }
        return messages
    }
    
    static func fetchRequestMessageByConversation(with Id:String, model: NSManagedObjectModel) -> NSFetchRequest<Message>? {
        let templateName = "MessagesByConversationId"
        
        guard let fetchRequest = model.fetchRequestFromTemplate(withName: templateName, substitutionVariables: ["Id" : Id]) as? NSFetchRequest<Message> else{
            assert(false,"No template with name \(templateName)")
            return nil
        }
        return fetchRequest
    }
    
    

    
}
