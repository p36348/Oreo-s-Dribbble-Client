//
//  RuntimeUtils.swift
//  OreosDrib
//
//  Created by P36348 on 20/6/2017.
//  Copyright © 2017 P36348. All rights reserved.
//

import Foundation

extension NSObject {
    
    /// 全部属性名称
    static var propertyNames: [String] {
        var outCount = UInt32(0)
        let properties = class_copyPropertyList(self.classForCoder(), &outCount)
        var _propertyNames: [String] = []
        for index in 0...(outCount-1) {
            let name = String(cString: property_getName(properties?[Int(index)]))
            _propertyNames.append(name)
        }
        return _propertyNames
    }
    
    /// 全部函数名称
    static var functionNames: [String] {
        var outCount = UInt32(0)
        let functions = class_copyMethodList(self.classForCoder(), &outCount)
        var _functionNames: [String] = []
        for index in 0...(outCount-1) {
            
            let name = String(cString: sel_getName(method_getName(functions?[Int(index)])))
            _functionNames.append(name)
        }
        return _functionNames
    }
}

private func propertyNames(ofClass class_t : AnyClass) -> [String]{
    var outCount = UInt32(0)
    let properties = class_copyPropertyList(class_t, &outCount)
    var propertyNames = [String]()
    for index in 0...(outCount-1) {
        let name = String(cString: property_getName(properties?[Int(index)]))
        propertyNames.append(name)
    }
    return propertyNames
}
