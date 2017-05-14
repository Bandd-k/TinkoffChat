//
//  CoreDataStack.swift
//  TinkoffChat
//
//  Created by Denis Karpenko on 19.04.17.
//  Copyright © 2017 Denis Karpenko. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataStack {
    static let sharedInstance: CoreDataStack = CoreDataStack()
    private var storeURL: URL{
        get{
            let documentsDirURL :URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let url = documentsDirURL.appendingPathComponent("Store.sqlite")
            return url
        }
    }
    private let managedObjectModelName = "TinkoffChat"
    private var _managedObjectModel : NSManagedObjectModel?
    private var managedObjectModel :NSManagedObjectModel? {
        get {
            if _managedObjectModel == nil{
                guard let modelURL = Bundle.main.url(forResource: managedObjectModelName, withExtension: "momd") else{
                    print("empy storage")
                    return nil
                }
                _managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)
            }
            return _managedObjectModel
        }
    }
    
    private var _persistentStoreCoordinator: NSPersistentStoreCoordinator?
    private var persistentStoreCoordinator: NSPersistentStoreCoordinator?{
        get{
            if _persistentStoreCoordinator == nil{
                guard let model = self.managedObjectModel else {
                    print("empy managed object model!")
                    return nil
                }
                _persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
                do{
                    try _persistentStoreCoordinator?.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
                } catch{
                    assert(false, "eror adding persistent store \(error)")
                }
            }
              return _persistentStoreCoordinator
            }
        }
    
    
    // Master context, save
    private var _masterContext: NSManagedObjectContext?
    private var masterContext : NSManagedObjectContext? {
        get {
            if _masterContext == nil {
                let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
                guard let persistentStoreCoordinator = self.persistentStoreCoordinator else {
                    print("empty persistent store coordinator!")
                    return nil
                }
                context.persistentStoreCoordinator = persistentStoreCoordinator
                context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
                context.undoManager = nil
                _masterContext = context
            }
            return _masterContext
        }
    }
    
    // Main context, ui
    private var _mainContext: NSManagedObjectContext?
    public var mainContext : NSManagedObjectContext? {
        get {
            if _masterContext == nil {
                let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
                guard let parentContext = self.masterContext else {
                    print("no Master Context!")
                    return nil
                }
                context.parent = parentContext
                context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
                context.undoManager = nil
                _mainContext = context
            }
            return _mainContext
        }
    }
    
    // Save context, import
    private var _saveContext: NSManagedObjectContext?
    public var saveContext : NSManagedObjectContext? {
        get {
            if _saveContext == nil {
                let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
                guard let parentContext = self.mainContext else {
                    print("no Main Context!")
                    return nil
                }
                context.parent = parentContext
                context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
                context.undoManager = nil
                _saveContext = context
            }
            return _saveContext
        }
    }

    
    
    public func performSave(context:NSManagedObjectContext,completionHandler: (()-> Void)? ){
        if context.hasChanges{
            print("context saved")
            context.perform { [weak self] in
                do{
                    try context.save()
                }
                catch{
                    print ("save error: \(error)")
                }
                if let parent = context.parent {
                    self?.performSave(context: parent, completionHandler: completionHandler)
                }
                else{
                    //DispatchQueue.main.async { // probably better to remove dispatch main
                        completionHandler?()
                    //}
                }
    
            }
            
        }
        else{
            //DispatchQueue.main.async {
                completionHandler?()
            //}
        }
    }
    
}

