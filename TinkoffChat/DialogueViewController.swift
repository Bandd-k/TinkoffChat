//
//  DialogueViewController.swift
//  TinkoffChat
//
//  Created by Denis Karpenko on 26.03.17.
//  Copyright © 2017 Denis Karpenko. All rights reserved.
//

import UIKit
import QuartzCore
class DialogueViewController: UIViewController,UITableViewDataSource {

    var messages:[String] = [String.random(length: 1),String.random(length: 30),String.random(length: 300)]
    @IBOutlet weak var messagesTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesTable.dataSource = self
        messagesTable.rowHeight = UITableViewAutomaticDimension
        messagesTable.estimatedRowHeight = 88
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row%2==0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "firstId", for: indexPath) as? MessageViewCell
            cell?.msgText = messages[indexPath.row]
            cell?.messageLabel.backgroundColor = UIColor(red: 102/255, green: 178/255, blue: 255/255, alpha: 1)
            cell?.messageLabel.layer.masksToBounds = true
            cell?.messageLabel.layer.cornerRadius = 3
            
            return cell!
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "secondId", for: indexPath) as? MessageViewCell
            cell?.msgText = messages[indexPath.row]
            cell?.messageLabel.backgroundColor = UIColor(red: 102/255, green: 255/255, blue: 102/255, alpha: 1)
            cell?.messageLabel.layer.masksToBounds = true
            cell?.messageLabel.layer.cornerRadius = 3
            return cell!
        }
    }


}
