//
//  FakeShotAPI.swift
//  OreosDrib
//
//  Created by P36348 on 14/08/2018.
//  Copyright © 2018 P36348. All rights reserved.
//

import Foundation
import Moya

enum FakeShotAPI {
    case popularShots(page: UInt, pageSize: UInt)
}

extension FakeShotAPI: BaseTargetType {
    
    var baseURL: URL {
//        return URL(string: "http://10.0.0.8:5000")!
        return URL(string: "http://localhost:5000")!
    }
    
    var path: String {
        switch self {
        case .popularShots:
            return "/popular_shots"
        }
    }
    
    var task: Task {
        switch self {
        case .popularShots(let page, let pageSize):
            return .requestParameters(parameters: ["page": page, "per_page": pageSize], encoding: Moya.URLEncoding.default)
        }
    }
}
