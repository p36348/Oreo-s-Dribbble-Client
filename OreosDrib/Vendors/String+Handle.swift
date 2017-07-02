//
//  String+Handle.swift
//  RacSwift
//
//  Created by P36348 on 8/5/2017.
//  Copyright © 2017 P36348. All rights reserved.
//

import Foundation

extension String {
    
    /// 正则判断是否移动电话号码
    var isValidMobile: Bool {
        let mobile = "1[3|5|7|8|][0-9]{9}"
        let  CM = "^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$"
        let  CU = "^1(3[0-2]|5[256]|8[56])\\d{8}$"
        let  CT = "^1((33|53|8[09])[0-9]|349)\\d{7}$"
        let regextestmobile = NSPredicate(format: "SELF MATCHES %@",mobile)
        let regextestcm = NSPredicate(format: "SELF MATCHES %@" ,CM)
        let regextestcu = NSPredicate(format: "SELF MATCHES %@" ,CU)
        let regextestct = NSPredicate(format: "SELF MATCHES %@" ,CT)
        return (regextestmobile.evaluate(with: self))
            || (regextestcm.evaluate(with: self))
            || (regextestct.evaluate(with: self))
            || (regextestcu.evaluate(with: self))
    }
    
    var isValidPassword: Bool {
        return characters.count >= 8 && characters.count <= 20
    }
    
    var isInt: Bool {
        return Int(self) != nil
    }
    
    var isDouble: Bool {
        return Double(self) != nil
    }
}

import UIKit

// MARK: - oss处理
extension String {
    func cutImageUrl(width: Int, height: Int) -> String{
        return self + "?x-oss-process=image/crop,x_0,y_0,w_\(width),h_\(height)"
    }
    func scaleImageUrl(scale: Double) -> String{
        return self + "?x-oss-process=image/resize,\(scale)"
    }

}
