//
//  runtime+UIControl.swift
//  Mazing
//
//  Created by P36348 on 5/3/2017.
//  Copyright © 2017 P36348. All rights reserved.
//

import UIKit

private var acceptEventIntervalKey: Int = 0
private var ignoreEventKey: Int = 0
private var defaultAcceptEventInterval: TimeInterval = 0

/**
 * 为避免太快的连续点击
 */
extension UIControl: SelfAware {
    /// 连续点击的时间间隔
    var acceptEventInterval: TimeInterval {
        
        set {
            objc_setAssociatedObject(self, &acceptEventIntervalKey, NSNumber(value: newValue), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            return objc_getAssociatedObject(self, &acceptEventIntervalKey) as? TimeInterval ?? defaultAcceptEventInterval
        }
    }
    /// 标记点击事件是否被忽略（第一点击后，时间间隔内的点击都被忽略）
    var ignoreEvent: Bool{
        
        set {
            objc_setAssociatedObject(self, &ignoreEventKey, NSNumber(value: newValue), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            return objc_getAssociatedObject(self, &ignoreEventKey) as? Bool ?? false
            
        }
    }
    
    /// 交换系统Button的方法sendAction:to:forEvent:的实现
    class func awake() {
        
        let sysMethod: Method = class_getInstanceMethod(self, #selector(sendAction(_:to:for:)))
        let customMethod: Method = class_getInstanceMethod(self, #selector(o_sendAction(_:to:for:)))
        method_exchangeImplementations(sysMethod, customMethod)
    }
    
    
    
    /// 自定义的sendAction:to:forEvent:实现，再次处理连续点击问题
    dynamic private func o_sendAction(_ action: Selector, to target: AnyObject, for event: UIEvent) {
        
        guard !ignoreEvent else {
            return
        }
        
        if self.acceptEventInterval > 0 {
            self.ignoreEvent = true
            self.perform(#selector(setMz_ignoreEvent), with:nil, afterDelay: self.acceptEventInterval)
        }
        
        self.o_sendAction(action, to: target, for: event)
    }
    
    dynamic private func setMz_ignoreEvent() {
        self.ignoreEvent = false
    }
}


protocol SelfAware: class {
    static func awake()
}


class NothingToSeeHere {
    
    static func harmlessFunction() {
        
        let typeCount = Int(objc_getClassList(nil, 0))
        let types = UnsafeMutablePointer<AnyClass?>.allocate(capacity: typeCount)
        let autoreleasingTypes = AutoreleasingUnsafeMutablePointer<AnyClass?>(types)
        objc_getClassList(autoreleasingTypes, Int32(typeCount))
        for index in 0 ..< typeCount { (types[index] as? SelfAware.Type)?.awake() }
        types.deallocate(capacity: typeCount)
        
    }
}


extension UIApplication {
    
    private static let runOnce: Void = {
        NothingToSeeHere.harmlessFunction()
    }()
    
    override open var next: UIResponder? {
        // Called before applicationDidFinishLaunching
        UIApplication.runOnce
        return super.next
    }
    
}
