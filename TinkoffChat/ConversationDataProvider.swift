//
//  ConversationDataProvider.swift
//  TinkoffChat
//
//  Created by Denis Karpenko on 07.05.17.
//  Copyright © 2017 Denis Karpenko. All rights reserved.
//

import Foundation
import UIKit
import CoreData
class ConversationDataProvider:NSObject {
    let fetchedResultsController: NSFetchedResultsController<Message>
    let tableView: UITableView
    init(tableView: UITableView,conversationId:String) {
        self.tableView = tableView
        let context = CoreDataStack.sharedInstance.mainContext
        let fetchRequest = NSFetchRequest<Message>(entityName: "Message")
        let predicate =
            NSPredicate(format: "conversation.conversationId == %@", conversationId)
        fetchRequest.predicate = predicate
        let sortByTimestamp = NSSortDescriptor(key: "date",ascending: false)
        fetchRequest.sortDescriptors = [sortByTimestamp]
        fetchedResultsController = NSFetchedResultsController<Message>(fetchRequest:
            fetchRequest, managedObjectContext: context!, sectionNameKeyPath: nil,
                          cacheName: nil)
        
        super.init()
        fetchedResultsController.delegate = self
    }
}

extension ConversationDataProvider: NSFetchedResultsControllerDelegate{
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange  anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        case .insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }
}

