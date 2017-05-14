//
//  StorageManager.swift
//  TinkoffChat
//
//  Created by Denis Karpenko on 02.05.17.
//  Copyright © 2017 Denis Karpenko. All rights reserved.
//

import Foundation
import UIKit

class StorageManager:StorageProtocol {
    
    let coreDataStack = CoreDataStack.sharedInstance
    func save(object: UserData,closure: @escaping ()->()){
        if let context = coreDataStack.saveContext  {
            let appUser = AppUser.findOrInsertAppUser(in: context)
            let user = User.findOrInsertUser(with: UIDevice.current.name, in: context)
            user?.isOnline = true
            user?.name = object.name
            appUser?.currentUser = user
            appUser?.about = object.about
            appUser?.name = object.name
            appUser?.labelColor = object.color
            appUser?.avatar = object.image
            coreDataStack.performSave(context: context, completionHandler: closure)
        }
        else{
            print ("No saveContext")
        }
    }
    func retrive(closure: @escaping (UserData?)->()){
        if let context = coreDataStack.mainContext  {
            let appUser = AppUser.findOrInsertAppUser(in: context)
            if let appUser = appUser{
            if appUser.avatar==nil && appUser.name==nil && appUser.labelColor==nil{
                closure(nil)
            }
            else{
                let retrievedInfo = UserData(name: appUser.name, image: appUser.avatar as? UIImage, about: appUser.about!, color: (appUser.labelColor as! UIColor))
                DispatchQueue.main.async {
                    closure(retrievedInfo)
                }
            }
            }
        }
        else{
            print ("No mainContext")
        }
    }
    
    func recieveMessage(text: String, fromUser: String,toUser:String){
        if let context = coreDataStack.saveContext {
            let message = Message.insertMessage(text: text, recieverId: toUser, senderId: fromUser, in: context)
            message?.isUnread = true
            let conversation = Conversation.findOrInsertConversation(with: String.generateConversationId(id1: fromUser, id2: toUser), in: context)
            conversation?.lastMessage = message
            coreDataStack.performSave(context: context, completionHandler: nil)
        }
    }
    func didFoundUser(userID:String,userName:String?){
        if let context = coreDataStack.saveContext {
            let user = User.findOrInsertUser(with: userID, in: context)
            user?.name = userName
            user?.isOnline = true
            // probably add save before
            let conversation = Conversation.findOrInsertConversation(with: String.generateConversationId(id1: userID, id2: UIDevice.current.name), in: context)
            let me = User.findOrInsertUser(with: UIDevice.current.name, in: context) // check then on AppUser
            conversation?.addToParticipants(user!)
            conversation?.addToParticipants(me!)
            conversation?.isOnline = true
            print (conversation?.conversationId)
            coreDataStack.performSave(context: context, completionHandler: nil)
        }
        
    }
    func didLostUser(userID:String){
        if let context = coreDataStack.saveContext {
            let user = User.findOrInsertUser(with: userID, in: context)
            user?.isOnline = false
            let conversation = Conversation.findOrInsertConversation(with: String.generateConversationId(id1: userID, id2: UIDevice.current.name), in: context)
            conversation?.isOnline = false
            coreDataStack.performSave(context: context, completionHandler: nil)
        }

    }
}
