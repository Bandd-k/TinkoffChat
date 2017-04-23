//
//  StorageManagers.swift
//  TinkoffChat
//
//  Created by Denis Karpenko on 04.04.17.
//  Copyright © 2017 Denis Karpenko. All rights reserved.
//

import Foundation
import UIKit

class GCDDataManager{
    func save(object: UserData,closure: @escaping ()->()){
        let globalQueue = DispatchQueue.global(qos: .utility)
        globalQueue.async {
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
    
}

