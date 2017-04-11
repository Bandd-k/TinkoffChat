//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by Denis Karpenko on 25.03.17.
//  Copyright © 2017 Denis Karpenko. All rights reserved.
//

import UIKit

// Возможно лучше было создать отдельный файл

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



let onlineUsers = 30
let offlineUsers = 20






class ConversationsListViewController: UIViewController,UITableViewDataSource{
    var dialoges: [cellData] = []
    let comm = Communicator.sharedInstance
    let man = CommunicationManager.sharedInstance
    @IBOutlet weak var dialoguesTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        dialoguesTable.dataSource = self
        //print(Communicator.sharedInstance)
        CommunicationManager.sharedInstance.controller = self
        //dialoguesTable.delegate = self

        // Do any additional setup after loading the view.
    }

    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "dialogue"{
            if let cell = sender as? ConversationsCell{
                //comm.sendMessage(string: "Hi From Den", to: cell.userID!, completionHandler: nil)
                if let dest = segue.destination as? DialogueViewController{
                    dest.userID = cell.userID
                    CommunicationManager.sharedInstance.chatController = dest
                    cell.hasUnreadedMessages = false
                    if let msg = cell.message{
                        dest.messages.append((msg,true))
                    }
                }
                
                segue.destination.navigationItem.title = cell.name
            }
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    
    }
    
    // MARK: - UITableViewDelegate

    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // в будущем считать элементы массива
        return self.dialoges.count
        if section==0{
            return onlineUsers
        }
        else{
            return offlineUsers
        }
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section==0){
            return "Online"
        }
        else{
            return "History"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as? ConversationsCell
        if(indexPath.section==0){
             cell?.configurate(data: dialoges[indexPath.row])
        }
        else{
            cell?.configurate(data: dialoges[onlineUsers+indexPath.row])
        }
        return cell!
    }

}
