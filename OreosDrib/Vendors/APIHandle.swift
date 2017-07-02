//
//  API.swift
//  OreosDrib
//
//  Created by P36348 on 6/6/2017.
//  Copyright © 2017 P36348. All rights reserved.
//

import Foundation

struct APIManager {
    
    private static let host: String = "https://api.dribbble.com/v1"
    
    
    /// 返回完整API的URL
    ///
    /// - Parameter apiPath: API路径
    /// - Returns: Dribbble接口完整URL
    static func generate(apiPath: String) -> String {
        return host + apiPath
    }
}



extension String {
    var dribbbleFullUrl: String {
        return APIManager.generate(apiPath: self)
    }
}

/*
 * http://developer.dribbble.com/v1/
 */
