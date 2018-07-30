//
//  UIFont+Extension.swift
//  OreosDrib
//
//  Created by P36348 on 20/6/2017.
//  Copyright © 2017 P36348. All rights reserved.
//

import Foundation
import UIKit
/**
 * http://iosfonts.com
 */

private let ArialMT: String = "ArialMT"

private let ArialBoldMT: String = "Arial-BoldMT"

private let PingFang: String = "PingFangSC-Regular"

private let PingFangBold: String = "PingFangSC-Medium"

// MARK: - theme
extension UIFont {
    
    static var title: UIFont {
        return UIFont(name: PingFang, size: 17)!
    }
    
    static var subTitle: UIFont {
        return UIFont(name: PingFang, size: 13)!
    }
    static var subTitleBold: UIFont {
        return UIFont(name: PingFangBold, size: 13)!
    }
    
    static var contentNormal: UIFont {
        return UIFont(name: PingFang, size: 15)!
    }
    
    static var contentBold: UIFont {
        return UIFont(name: PingFangBold, size: 15)!
    }
    
    static var button: UIFont {
        return UIFont(name: PingFang, size: 17)!
    }
    
    static var link: UIFont {
        return UIFont(name: PingFangBold, size: 15)!
    }
    
}

// MARK: - caculate
extension UIFont {
    func size(of string: String, maxWidth: CGFloat) -> CGSize {
        
        return NSString(string: string).boundingRect(with: CGSize(width: Double(maxWidth), height: Double.greatestFiniteMagnitude),
                                                     options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                     attributes: [NSAttributedStringKey.font: self],
                                                     context: nil).size
    }
    
    func size(of string: String, maxHeight: CGFloat) -> CGSize {
        return NSString(string: string).boundingRect(with: CGSize(width: Double.greatestFiniteMagnitude, height: Double(maxHeight)),
                                                     options: NSStringDrawingOptions.usesFontLeading,
                                                     attributes: [NSAttributedStringKey.font: self],
                                                     context: nil).size
    }
}
