//
//  OperationDataManager.swift
//  TinkoffChat
//
//  Created by Denis Karpenko on 21.04.17.
//  Copyright © 2017 Denis Karpenko. All rights reserved.
//

import Foundation
import UIKit


class OperationDataManager{
    func save(object: UserData,closure: @escaping ()->()){
        let queue = OperationQueue()
        let op = myOperationSave(object: object,closure: closure)
        queue.addOperation(op)
    }
    
    func retrive(closure: @escaping (UserData?)->()){
        let queue = OperationQueue()
        let op = myOperationDownload(closure: closure)
        queue.addOperation(op)
    }
    
}

class myOperationSave: Operation{
    
    init(object: UserData,closure: @escaping ()->()){
        self.toSave = object
        self.clos = closure
        super.init()
    }
    var toSave: UserData
    var clos:()->()
    override var isAsynchronous: Bool {
        return true
    }
    override func start() {
        _executing = true
        execute()
    }
    
    private var _executing = false {
        willSet {
            willChangeValue(forKey: "isExecuting")
        }
        didSet {
            didChangeValue(forKey: "isExecuting")
        }
    }
    
    private var _finished = false {
        willSet {
            willChangeValue(forKey: "isFinished")
        }
        
        didSet {
            didChangeValue(forKey: "isFinished")
        }
    }
    
    override var isExecuting: Bool {
        return _executing
    }
    
    
    func execute() {
        let savedData = NSKeyedArchiver.archivedData(withRootObject: toSave)
        let defaults = UserDefaults.standard
        defaults.set(savedData, forKey: "user")
        DispatchQueue.main.async {
            self.clos()
        }
        finish()
    }
    func finish() {
        
        _executing = false
        _finished = true
    }
    
}

class myOperationDownload: Operation{
    
    init(closure: @escaping (UserData?)->()){
        self.clos = closure
        super.init()
    }
    var clos:(UserData?)->()
    override var isAsynchronous: Bool {
        return true
    }
    override func start() {
        _executing = true
        execute()
    }
    
    private var _executing = false {
        willSet {
            willChangeValue(forKey: "isExecuting")
        }
        didSet {
            didChangeValue(forKey: "isExecuting")
        }
    }
    
    private var _finished = false {
        willSet {
            willChangeValue(forKey: "isFinished")
        }
        
        didSet {
            didChangeValue(forKey: "isFinished")
        }
    }
    
    override var isExecuting: Bool {
        return _executing
    }
    
    
    func execute() {
        let defaults = UserDefaults.standard
        var user:UserData? = nil
        if let savedData = defaults.object(forKey: "user") as? Data {
            user = NSKeyedUnarchiver.unarchiveObject(with: savedData) as? UserData
        }
        DispatchQueue.main.async {
            self.clos(user)
        }
        finish()
    }
    func finish() {
        
        _executing = false
        _finished = true
    }
    
}
