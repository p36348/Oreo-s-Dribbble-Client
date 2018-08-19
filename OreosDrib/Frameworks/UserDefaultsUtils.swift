//
//  UserDefaultsUtils.swift
//  ThinkerBaseKit
//
//  Created by P36348 on 17/03/2018.
//  Copyright © 2018 ThinkerVC. All rights reserved.
//

import Foundation

public protocol UserDefaultable {
    associatedtype E
    
    static func objectUserDefaults(forKey key: String) -> E?
}

extension UserDefaultable {
    public static func objectUserDefaults(forKey key: String) -> E? {
        return UserDefaults.standard.value(forKey: key) as? E
    }
}

extension Bool: UserDefaultable {
    public typealias E = Bool
}

extension Int: UserDefaultable {
    public typealias E = Int
}

extension Int32: UserDefaultable {
    public typealias E = Int32
}

extension Int64: UserDefaultable {
    public typealias E = Int64
}

extension String: UserDefaultable {
    public typealias E = String
}

extension Double: UserDefaultable {
    public typealias E = Double
}

extension Data: UserDefaultable {
    public typealias E = Data
}

extension Array: UserDefaultable {
    public typealias E = Array
}

public func objectUserDefaults(forKey key: String) -> Any? {
    return UserDefaults.standard.value(forKey: key)
}

public func setUserDefaults(value: Any?, forKey key: String) {
    UserDefaults.standard.set(value, forKey: key)
    UserDefaults.standard.synchronize()
}

public func removeUserDefaults(forKey key: String) {
    UserDefaults.standard.removeObject(forKey: key)
    UserDefaults.standard.synchronize()
}


