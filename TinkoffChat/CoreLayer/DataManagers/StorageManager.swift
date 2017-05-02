//
//  StorageManager.swift
//  TinkoffChat
//
//  Created by Denis Karpenko on 02.05.17.
//  Copyright © 2017 Denis Karpenko. All rights reserved.
//

import Foundation
import UIKit

class StorageManager {
    let coreDataStack = CoreDataStack()
    func save(object: UserData,closure: @escaping ()->()){
        if let context = coreDataStack.saveContext  {
        let appUser = AppUser.findOrInsertAppUser(in: context)
        appUser?.about = object.about
        appUser?.name = object.name
        appUser?.labelColor = object.color
        appUser?.avatar = object.image
        coreDataStack.performSave(context: context, completionHandler: closure)
        }
        else{
            print ("No saveContext")
        }
    }
    func retrive(closure: @escaping (UserData?)->()){
        if let context = coreDataStack.mainContext  {
            let appUser = AppUser.findOrInsertAppUser(in: context)
            if let appUser = appUser{
            if appUser.avatar==nil && appUser.name==nil && appUser.labelColor==nil{
                closure(nil)
            }
            else{
                let retrievedInfo = UserData(name: appUser.name, image: appUser.avatar as? UIImage, about: appUser.about!, color: (appUser.labelColor as! UIColor))
                DispatchQueue.main.async {
                    closure(retrievedInfo)
                }
            }
            }
        }
        else{
            print ("No mainContext")
        }
    }
}
