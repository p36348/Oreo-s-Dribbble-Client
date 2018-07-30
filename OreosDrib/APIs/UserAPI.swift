//
//  UserAPI.swift
//  OreosDrib
//
//  Created by P36348 on 29/07/2018.
//  Copyright © 2018 P36348. All rights reserved.
//

import Foundation
import Moya

enum UserAPI {
    case authenticatedUser, authenticatedUserBuckets, authenticatedFollowers, authenticatedFollowing, singleUser(uid: String), userBuckets(uid: String), followers(uid: String), following(uid: String)
}

extension UserAPI: BaseTargetType {
    
    var path: String {
        switch self {
        case .authenticatedUser:
            return "/user"
        case .authenticatedUserBuckets:
            return "/user/buckets"
        case .authenticatedFollowers:
            return "/user/followers"
        case .authenticatedFollowing:
            return "/user/following"
        case .singleUser(let uid):
            return "/user/\(uid)"
        case .userBuckets(let uid):
            return "/user/\(uid)/buckets"
        case .followers(let uid):
            return "/user/\(uid)/followers"
        case .following(let uid):
            return "/user/\(uid)/following"
        }
    }
}
