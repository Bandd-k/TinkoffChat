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
    init(name:String?,message:String?,date:Date?,online:Bool,hasUnreaded:Bool) {
        self.name = name
        self.message = message
        self.date = date
        self.online = online
        self.hasUnreadedMessages = hasUnreaded
    }
    var name: String?
    var message: String?
    var date:Date?
    var online:Bool
    var hasUnreadedMessages:Bool
}


var dialoges: [cellData] = generator()

let onlineUsers = 30
let offlineUsers = 20

func generator()->[cellData]{
    var array:[cellData] = []
    for index in 1...onlineUsers{
        array.append(cellData(name: String.random(length: 1+Int(arc4random_uniform(5))), message: String.random(length: Int(arc4random_uniform(10))), date: Date.init(timeIntervalSinceNow: TimeInterval(-1 * Int(arc4random_uniform(24*60*60*2)))), online: true, hasUnreaded: index%5==0))
    }
    for index in 1...offlineUsers{
        array.append(cellData(name: String.random(length: 1+Int(arc4random_uniform(5))), message: String.random(length: Int(arc4random_uniform(10))), date: Date.init(timeIntervalSinceNow: TimeInterval(-1 * Int(arc4random_uniform(24*60*60*2)))), online: false, hasUnreaded: index%4==0))
    }
    return array
}


class ConversationsListViewController: UIViewController,UITableViewDataSource{

    @IBOutlet weak var dialoguesTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        dialoguesTable.dataSource = self
        //dialoguesTable.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "dialogue"{
            if let cell = sender as? ConversationsCell{
                segue.destination.navigationItem.title = cell.name
            }
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    
    }
    
    // MARK: - UITableViewDelegate

    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // в будущем считать элементы массива
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
