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


protocol StorageProtocol: class {
    func recieveMessage(text: String, fromUser: String,toUser:String)
    func didFoundUser(userID:String,userName:String?)
    func didLostUser(userID:String)
}




class CommunicationManager: CommunicatorDelegate{
    let communicator = Communicator()
    let storageManager:StorageProtocol?
    
    init(manager:StorageProtocol){
        storageManager = manager
        communicator.delegate = self
        print("CommunicationManager inited")
    }
    // Discovering
    
    
    
    
    func sendMessage(string:String,to userID:String,completionHandler: ((_ success: Bool,_ error: Error?)->())?){
        storageManager?.recieveMessage(text: string, fromUser: UIDevice.current.name, toUser: userID)
        communicator.sendMessage(string: string, to: userID
            , completionHandler: completionHandler)
    }
    
    func didFoundUser(userID:String,userName:String?){
        storageManager?.didFoundUser(userID: userID, userName: userName)
    }
    func didLostUser(userID:String){
        //controller?.deleteUser(userID: userID)
        //chatController?.deleteUser(userID: userID)
        storageManager?.didLostUser(userID: userID)
        
    }
    
    //errors
    func failedToStartBrowsingForUsers(error: Error){
        //controller?.showAlert(error: error)
        //chatController?.showAlert(error: error)
        
    }
    func failedToStartAdvertising(error: Error){
        //controller?.showAlert(error: error)
       // chatController?.showAlert(error: error)
        
    }
    
    //messages
    func didReceiveMessage(text: String, fromUser: String,toUser: String){
        let systemSoundID: SystemSoundID = 1016
        AudioServicesPlaySystemSound (systemSoundID)
        storageManager?.recieveMessage(text: text, fromUser: fromUser, toUser: toUser)
    }
}
