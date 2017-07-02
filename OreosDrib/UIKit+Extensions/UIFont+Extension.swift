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

// MARK: - theme
extension UIFont {
    
    static var title: UIFont {
        return UIFont(name: ArialMT, size: 17)!
    }
    
    static var contentNormal: UIFont {
        return UIFont(name: ArialMT, size: 15)!
    }
    
    static var contentBold: UIFont {
        return UIFont(name: ArialBoldMT, size: 15)!
    }
    
    static var button: UIFont {
        return UIFont(name: ArialMT, size: 17)!
    }
    
}

// MARK: - caculate
extension UIFont {
    func size(of string: String, maxWidth: CGFloat) -> CGSize {
        return NSString(string: string).boundingRect(with: CGSize(width: Double(maxWidth), height: Double.greatestFiniteMagnitude),
                                                     options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                     attributes: [NSFontAttributeName: self],
                                                     context: nil).size
    }
    
    func size(of string: String, maxHeight: CGFloat) -> CGSize {
        return NSString(string: string).boundingRect(with: CGSize(width: Double.greatestFiniteMagnitude, height: Double(maxHeight)),
                                                     options: NSStringDrawingOptions.usesFontLeading,
                                                     attributes: [NSFontAttributeName: self],
                                                     context: nil).size
    }
}
