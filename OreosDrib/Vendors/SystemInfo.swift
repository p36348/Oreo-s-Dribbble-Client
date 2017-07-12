//
//  SystemInfo.swift
//  RacSwift
//
//  Created by P36348 on 23/5/2017.
//  Copyright © 2017 P36348. All rights reserved.
//

import Foundation
import UIKit
struct SystemInfo {
    
    static var language: String {
        return Locale.preferredLanguages.first ?? "unknow"
    }
    
//    static var screenSize: CGSize {
//        return UIScreen.main.bounds.size
//    }
    
    static var deviceModel: String {
        return UIDevice.current.model
    }
    
    static var systemVersion: String {
        return UIDevice.current.systemVersion
    }
}

var kScreenWidth: CGFloat {
    return UIScreen.main.bounds.size.width
}

var kScreenHeight: CGFloat {
    return UIScreen.main.bounds.size.height
}
