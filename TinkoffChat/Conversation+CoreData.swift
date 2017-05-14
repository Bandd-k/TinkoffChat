//
//  Conversation+CoreData.swift
//  TinkoffChat
//
//  Created by Denis Karpenko on 08.05.17.
//  Copyright © 2017 Denis Karpenko. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension Conversation {
    static func insertConversation(with Id:String,in context:NSManagedObjectContext) -> Conversation?{
        if let conversation = NSEntityDescription.insertNewObject(forEntityName: "Conversation", into: context) as? Conversation {
            conversation.conversationId = Id
            return conversation
        }
        return nil

        
    }
    
    
    static func findOrInsertConversation(with Id:String,in context:NSManagedObjectContext) -> Conversation?{
        if let conversation = findConversation(with: Id, in: context){
            return conversation
        }
        else{
            return insertConversation(with: Id, in: context)
        }
        
    }
    
    static func findConversation(with Id:String,in context:NSManagedObjectContext) -> Conversation?{
        guard let model = context.persistentStoreCoordinator?.managedObjectModel else {
            print ("Model is not available in context")
            assert(false)
            return nil
        }
        var conversation : Conversation?
        guard let fetchRequest = Conversation.fetchRequestConversation(with: Id,model: model) else {
            return nil
        }
        do {
            let results = try context.fetch(fetchRequest)
            assert(results.count < 2, "Multiple Conversations found!")
            if let foundConversation = results.first{
                conversation = foundConversation
            }
        } catch {
            print ("Failed to fetch conversation: \(error)")
        }
        return conversation

        
    }
    
    
    static func fetchRequestConversation(with Id:String, model: NSManagedObjectModel) -> NSFetchRequest<Conversation>? {
        let templateName = "ConversationId"
        
        guard let fetchRequest = model.fetchRequestFromTemplate(withName: templateName, substitutionVariables: ["Id" : Id]) as? NSFetchRequest<Conversation> else{
            assert(false,"No template with name \(templateName)")
            return nil
        }
        return fetchRequest
    }
}
