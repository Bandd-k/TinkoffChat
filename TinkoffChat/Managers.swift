//
//  Managers.swift
//  TinkoffChat
//
//  Created by Denis Karpenko on 04.04.17.
//  Copyright © 2017 Denis Karpenko. All rights reserved.
//

import Foundation
import UIKit

class UserData:NSObject,NSCoding{
    var name: String?
    var image: UIImage?
    var about: String
    var color: UIColor
    init(name:String?, image:UIImage?, about:String, color:UIColor) {
        self.name = name
        self.image = image
        self.about = about
        self.color = color
    }
    
    required init(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as? String
        image = aDecoder.decodeObject(forKey: "image") as? UIImage
        about = aDecoder.decodeObject(forKey: "about") as! String
        color = aDecoder.decodeObject(forKey: "color") as! UIColor
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(image, forKey: "image")
        aCoder.encode(about, forKey: "about")
        aCoder.encode(color, forKey: "color")
    }
    
}

class GCDDataManager{
    func save(object: UserData,closure: @escaping ()->()){
        let globalQueue = DispatchQueue.global(qos: .utility)
        globalQueue.async {
            sleep(1)
            let savedData = NSKeyedArchiver.archivedData(withRootObject: object)
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "user")
            DispatchQueue.main.async {
                closure()
            }
        }
    }
    func retrive(closure: @escaping (UserData?)->()){
        let defaults = UserDefaults.standard
        let globalQueue = DispatchQueue.global(qos: .utility)
        globalQueue.async {
            var user:UserData? = nil
        if let savedData = defaults.object(forKey: "user") as? Data {
            user = NSKeyedUnarchiver.unarchiveObject(with: savedData) as? UserData
        }
            DispatchQueue.main.async {
                closure(user)
            }

        }
    }
    static let sharedInstance: GCDDataManager = GCDDataManager()
    
}



// Не совсем уверен в правильности этой части :))))


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
    
    static let sharedInstance: OperationDataManager = OperationDataManager()
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
        sleep(1)
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
        sleep(1)
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

