//
//  ListDataProvider.swift
//  TinkoffChat
//
//  Created by Denis Karpenko on 09.05.17.
//  Copyright © 2017 Denis Karpenko. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class ListDataProvider:NSObject {
    let fetchedResultsController: NSFetchedResultsController<Conversation>
    let tableView: UITableView
    init(tableView: UITableView) {
        self.tableView = tableView
        let context = CoreDataStack.sharedInstance.mainContext
        let fetchRequest = NSFetchRequest<Conversation>(entityName: "Conversation")
        let sortByTimestamp = NSSortDescriptor(key: "conversationId",ascending: false)
        fetchRequest.sortDescriptors = [sortByTimestamp]
        fetchedResultsController = NSFetchedResultsController<Conversation>(fetchRequest:
            fetchRequest, managedObjectContext: context!, sectionNameKeyPath: nil,
                          cacheName: nil)
        
        super.init()
        fetchedResultsController.delegate = self
        print ("ListData inited")
    }
}

extension ListDataProvider: NSFetchedResultsControllerDelegate{
    
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
        print("inside FetchController")
        print (type)
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

