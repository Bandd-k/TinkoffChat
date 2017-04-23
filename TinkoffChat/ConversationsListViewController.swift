//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by Denis Karpenko on 25.03.17.
//  Copyright © 2017 Denis Karpenko. All rights reserved.
//

import UIKit

class ConversationsListViewController: UIViewController,UITableViewDataSource,MessageReciever{
    var dialoges: [cellData] = []
    let comManager = CommunicationManager()
    @IBOutlet weak var dialoguesTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        dialoguesTable.dataSource = self
        //print(Communicator.sharedInstance)
        comManager.controller = self
        //dialoguesTable.delegate = self
        // Do any additional setup after loading the view.
    

    
    }
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "dialogue"{
            if let cell = sender as? ConversationsCell{
                if let dest = segue.destination as? DialogueViewController{
                    dest.userID = cell.userID
                    dest.comManager = comManager
                    comManager.chatController = dest
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
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Online"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath)
        if let cell = cell as? ConversationsCell{
             cell.configurate(data: dialoges[indexPath.row])
            return cell
        }
        return cell
    }

    // MARK: - MessageReciever
    
    func recieveMessage(text: String, fromUser: String,read: Bool)->Bool{
        for (index,dialog) in dialoges.enumerated(){
            if dialog.userID == fromUser{
                dialoges[index].message = text
                dialoges[index].date = Date()
                // make unread
                if !read{
                    dialoges[index].hasUnreadedMessages = true
                }
                else{
                    dialoges[index].hasUnreadedMessages = false
                }
                DispatchQueue.main.async{
                    self.dialoguesTable.reloadData()
                }
            }
        }
        return false
    }
    
    func deleteUser(userID:String){
        for (index,dialog) in dialoges.enumerated(){
            if dialog.userID == userID{
                dialoges.remove(at: index)
                DispatchQueue.main.async{
                    self.dialoguesTable.reloadData()
                }
            }
        }
    }
    func addUser(userID:String,userName:String?){
        let data:cellData = cellData(name: userName,userID:userID, message: nil, date: Date(), online: true, hasUnreaded: false)
        dialoges.insert(data, at: 0)
        DispatchQueue.main.async{
            self.dialoguesTable.reloadData()
        }
    }
    func showAlert(error:Error){
        let alert = UIAlertController(title: error.localizedDescription, message:nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Ок", style: .default) { action in
        })
        self.present(alert,animated: true)
    }
}
