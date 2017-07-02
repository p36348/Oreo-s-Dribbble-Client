//
//  RealmManager.swift
//  OreosDrib
//
//  Created by P36348 on 21/6/2017.
//  Copyright © 2017 P36348. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

struct RealmManager {
    static var shared: RealmManager = RealmManager()
    private init() {}
    
    private var realms: [String: Realm] = [:]
    
    mutating func dataBase(of uid: String) -> Realm {
        let schemVersion = UInt64(Bundle.main.infoDictionary!["CFBundleVersion"] as! String)!
        let containUser = realms.keys.contains { (key) -> Bool in
            return key == uid
        }
        
        guard !containUser else {
            return realms[uid]!
        }
        let critLock = NSLock()
        critLock.lock()
        do{
            
            let fileURL: URL = Realm.Configuration.defaultConfiguration.fileURL!.deletingLastPathComponent().appendingPathComponent("User" + uid).appendingPathExtension("realm")
            
            
            
            let configuration: Realm.Configuration = Realm.Configuration(fileURL: fileURL,schemaVersion: schemVersion, migrationBlock: { (migration, oldSchemaVersion) in
                
            })
            
            realms[uid] = try Realm(configuration: configuration)
        }catch{
            print("realm init fail")
        }
        critLock.unlock()
        
        guard let _instance = realms[uid] else {
            let __instance: Realm = (try! Realm())
            realms[uid] = __instance
            return __instance
        }
        realms[uid] = _instance
        return _instance
    }
}
