//
//  MCCommutator.swift
//  TinkoffChat
//
//  Created by Denis Karpenko on 07.04.17.
//  Copyright © 2017 Denis Karpenko. All rights reserved.
//

import Foundation
import UIKit
import MultipeerConnectivity
import AVFoundation
class Communicator: NSObject{
    private let serviceBrowser : MCNearbyServiceBrowser
    private let serviceAdvertiser : MCNearbyServiceAdvertiser
    private let serviceType =  "tinkoff-chat"
    let discoveryInfo = [ "userName" : "DenisKarpenko"]
    let myPeerId = MCPeerID(displayName: UIDevice.current.name)
    var sessions: [String:MCSession] = [:] //dispname: session
    var names: [String:String] = [:]
    static let sharedInstance: Communicator = Communicator()
    var delegate: CommunicatorDelegate? = CommunicationManager.sharedInstance//{get set}
    var online: Bool = true //{get set}
    
    
    override init() {
        print( "Communicator initialized")
        self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo:discoveryInfo , serviceType: serviceType)
        self.serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: serviceType)
        
        super.init()
        self.serviceBrowser.delegate = self
        self.serviceBrowser.startBrowsingForPeers()
        self.serviceAdvertiser.startAdvertisingPeer()
        self.serviceAdvertiser.delegate = self
    }
    
    
    
    
    func sendMessage(string:String,to userID:String,completionHandler: ((_ success: Bool,_ error: Error?)->())?){
        let message = ["eventType":"TextMessage","messageId":String.generateMessageId(),"text":string]
        do {
            let dataExample = try JSONSerialization.data(withJSONObject: message, options: .prettyPrinted)
            do {
                if let session = self.sessions[userID]{
                try session.send(dataExample, toPeers: (session.connectedPeers), with: .reliable)
                }
            }
            catch let error {
                completionHandler?(false,error)
            }
        }
        catch{
            completionHandler?(false,nil)
        }
        completionHandler?(true,nil)
        

    }
}

extension Communicator : MCNearbyServiceAdvertiserDelegate {
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        self.delegate?.failedToStartAdvertising(error: error)
        //NSLog("%@", "didNotStartAdvertisingPeer: \(error)")
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        NSLog("%@", "didReceiveInvitationFromPeer \(peerID)")
        //if((names[peerID.displayName] != nil)){
        print("Inside")
        let session = MCSession(peer: self.myPeerId, securityIdentity: nil, encryptionPreference: .none)
        invitationHandler(true, session)
        session.delegate = self
        self.sessions[peerID.displayName] = session
        //}
    }
    
}


extension Communicator : MCNearbyServiceBrowserDelegate {
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        delegate?.failedToStartBrowsingForUsers(error: error)
        //NSLog("%@", "didNotStartBrowsingForPeers: \(error)")
    }

    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        // add if already exist
        if let name = info?["userName"]{
            names[peerID.displayName] = name
            print ("founded")
            if self.sessions[peerID.displayName] == nil{
                print ("added")
            let session = MCSession(peer: self.myPeerId, securityIdentity: nil, encryptionPreference: .none)
            session.delegate = self
            self.sessions[peerID.displayName] = session
            browser.invitePeer(peerID, to: session, withContext: nil, timeout: 30)
            }
        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        //NSLog("%@", "lostPeer: \(peerID)")
    }
    
}
extension Communicator : MCSessionDelegate {
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        NSLog("%@", "peer \(peerID) didChangeState: \(state.rawValue)")
        if(state == .connected){
            delegate?.didFoundUser(userID: peerID.displayName, userName: names[peerID.displayName])
        }
        if(state == .notConnected){
            self.sessions.removeValue(forKey: peerID.displayName)
            delegate?.didLostUser(userID: peerID.displayName)
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {

        
        do {
            var data = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:String]
            //data["text"] ?? text
            //data["messageId"] ???
            //add nil handlers
            delegate?.didReceiveMessage(text: data["text"]!, fromUser: peerID.displayName, toUser: self.discoveryInfo["userName"]!)
        }
        catch{
            print ("error")
        }
        NSLog("%@", "didReceiveData: \(data)")
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        //NSLog("%@", "didReceiveStream")
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        //NSLog("%@", "didStartReceivingResourceWithName")
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) {
        //NSLog("%@", "didFinishReceivingResourceWithName")
    }
}


protocol CommunicatorDelegate: class {
    func didFoundUser(userID:String,userName:String?)
    func didLostUser(userID:String)
    
    //errors
    func failedToStartBrowsingForUsers(error: Error)
    func failedToStartAdvertising(error: Error)
    
    //messages
    func didReceiveMessage(text: String, fromUser: String,toUser: String)
}



class CommunicationManager: CommunicatorDelegate{
    weak var controller: ConversationsListViewController?
    weak var chatController: DialogueViewController?
    
    init(){
        print("inited")
    }
    static let sharedInstance: CommunicationManager = CommunicationManager()
    // Discovering
    func didFoundUser(userID:String,userName:String?){
        let data:cellData = cellData(name: userName,userID:userID, message: userID, date: Date(), online: true, hasUnreaded: false)
        self.controller?.dialoges.insert(data, at: 0)
        DispatchQueue.main.async{
            self.controller?.dialoguesTable.reloadData()
        }
        // add to chat
        
    }
    func didLostUser(userID:String){
        for (index,dialog) in (controller?.dialoges)!.enumerated(){
            if dialog.userID == userID{
                controller?.dialoges.remove(at: index)
                DispatchQueue.main.async{
                    self.controller?.dialoguesTable.reloadData()
                }
            }
        }
        
    }
    
    //errors
    func failedToStartBrowsingForUsers(error: Error){
        
    }
    func failedToStartAdvertising(error: Error){
        
    }
    
    //messages
    func didReceiveMessage(text: String, fromUser: String,toUser: String){
        let systemSoundID: SystemSoundID = 1016
        AudioServicesPlaySystemSound (systemSoundID)
        if self.chatController?.userID == fromUser{
            print("recieved")
            self.chatController?.messages.append((text,true))
            DispatchQueue.main.async{
                self.chatController?.messagesTable.reloadData()
            }
            
        }
        for (index,dialog) in (controller?.dialoges)!.enumerated(){
            if dialog.userID == fromUser{
                controller?.dialoges[index].message = text
                controller?.dialoges[index].date = Date()
                controller?.dialoges[index].hasUnreadedMessages = true
                DispatchQueue.main.async{
                    self.controller?.dialoguesTable.reloadData()
                }
            }
        }
    }
    
    
    
}