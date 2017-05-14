//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by Denis Karpenko on 25.03.17.
//  Copyright © 2017 Denis Karpenko. All rights reserved.
//

import UIKit
import CoreData

class ConversationsListViewController: UIViewController,UITableViewDataSource{
    var comManager:CommunicationManager?
    let storageManager = StorageManager()
    var fetchedResultsController: NSFetchedResultsController<Conversation>?
    var provider : ListDataProvider?
    @IBOutlet weak var dialoguesTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        dialoguesTable.dataSource = self
        //print(Communicator.sharedInstance)
        comManager = CommunicationManager(manager: storageManager)
        provider = ListDataProvider(tableView: dialoguesTable)
        fetchedResultsController = provider?.fetchedResultsController
            //dialoguesTable.delegate = self
        // Do any additional setup after loading the view.
    }
    // MARK: - Navigation
    
    override func viewWillAppear(_ animated: Bool) {
        do {
            try self.fetchedResultsController?.performFetch()
        } catch {
            print("Error fetching: \(error)")
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "dialogue"{
            if let cell = sender as? ConversationsCell{
                if let dest = segue.destination as? DialogueViewController{
                    dest.userID = cell.userID
                    dest.comManager = comManager
                    dest.conversationId = cell.conversationId
                    //cell.hasUnreadedMessages = false
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
        guard let frc = fetchedResultsController, let sectionsCount =
            frc.sections?.count else {
                return 0 }
        return sectionsCount
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let frc = fetchedResultsController, let sections = frc.sections else {
            return 0 }
        return sections[section].numberOfObjects
    }
    

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Online"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath)
        if let cell = cell as? ConversationsCell{
            if let info = fetchedResultsController?.object(at: indexPath) {
                cell.configurate(data:info)
            }
            return cell
        }
        return cell
    }

    // MARK: - MessageReciever
    
    func showAlert(error:Error){
        let alert = UIAlertController(title: error.localizedDescription, message:nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Ок", style: .default) { action in
        })
        self.present(alert,animated: true)
    }
}
