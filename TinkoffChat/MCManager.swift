//
//  MCManager.swift
//  TinkoffChat
//
//  Created by Denis Karpenko on 21.04.17.
//  Copyright © 2017 Denis Karpenko. All rights reserved.
//

import Foundation
import UIKit
import MultipeerConnectivity
import AVFoundation

protocol CommunicatorDelegate: class {
    func didFoundUser(userID:String,userName:String?)
    func didLostUser(userID:String)
    
    //errors
    func failedToStartBrowsingForUsers(error: Error)
    func failedToStartAdvertising(error: Error)
    
    //messages
    func didReceiveMessage(text: String, fromUser: String,toUser: String)
}




// Interaction with MC protocols
protocol MessageReciever: class{
    func recieveMessage(text: String, fromUser: String,read:Bool)->Bool
    func deleteUser(userID:String)
    func addUser(userID:String,userName:String?)
    func showAlert(error:Error)
}




class CommunicationManager: CommunicatorDelegate{
    weak var controller: MessageReciever?
    weak var chatController: MessageReciever?
    let communicator = Communicator()
    
    init(){
        communicator.delegate = self
        print("CommunicationManager inited")
    }
    // Discovering
    
    
    
    
    func sendMessage(string:String,to userID:String,completionHandler: ((_ success: Bool,_ error: Error?)->())?){
        communicator.sendMessage(string: string, to: userID
            , completionHandler: completionHandler)
    }
    
    func didFoundUser(userID:String,userName:String?){
        controller?.addUser(userID: userID, userName: userName)
        chatController?.addUser(userID: userID, userName: userName)
        // add to chat
        
    }
    func didLostUser(userID:String){
        controller?.deleteUser(userID: userID)
        chatController?.deleteUser(userID: userID)
        
    }
    
    //errors
    func failedToStartBrowsingForUsers(error: Error){
        controller?.showAlert(error: error)
        chatController?.showAlert(error: error)
        
    }
    func failedToStartAdvertising(error: Error){
        controller?.showAlert(error: error)
        chatController?.showAlert(error: error)
        
    }
    
    //messages
    func didReceiveMessage(text: String, fromUser: String,toUser: String){
        let systemSoundID: SystemSoundID = 1016
        AudioServicesPlaySystemSound (systemSoundID)
        let showed = chatController?.recieveMessage(text: text, fromUser: fromUser,read:false)
        if let showed = showed{
            controller?.recieveMessage(text: text, fromUser: fromUser,read:showed)
        }
        else{
            controller?.recieveMessage(text: text, fromUser: fromUser,read:false)
        }
        
        
    }
    
    
    
}
