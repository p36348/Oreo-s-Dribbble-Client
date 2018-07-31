//
//  UserAPI.swift
//  OreosDrib
//
//  Created by P36348 on 29/07/2018.
//  Copyright © 2018 P36348. All rights reserved.
//

import Foundation
import Moya

// MARK: http://developer.dribbble.com/v2/user/
enum UserAPI {
    case authenticatedUser
}

extension UserAPI: BaseTargetType {
    
    var path: String {
        switch self {
        case .authenticatedUser:
            return "/user"
        }
    }
}
