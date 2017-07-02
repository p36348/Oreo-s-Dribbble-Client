//
//  Dictionary+Handle.swift
//  RacSwift
//
//  Created by P36348 on 23/5/2017.
//  Copyright © 2017 P36348. All rights reserved.
//

import Foundation


/// 键值对合并操作
///
/// - Parameters:
///   - left: 要更新的字典
///   - right: 被合并的字典
func += <KeyType, ValueType> ( left: inout Dictionary<KeyType, ValueType>, right: Dictionary<KeyType, ValueType>) {
    for (k, v) in right {
        left.updateValue(v, forKey: k)
    }
}
