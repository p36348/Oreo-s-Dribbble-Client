//
//  BaseTargetType.swift
//  OreosDrib
//
//  Created by P36348 on 29/07/2018.
//  Copyright © 2018 P36348. All rights reserved.
//

import Foundation
import Moya

public protocol BaseTargetType: TargetType {
    
}

extension BaseTargetType {
    public var baseURL: URL {
        return URL(string: "https://api.dribbble.com/v1")!
    }
    
    public var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    public var headers: [String : String]? {
        return ["Authorization": "Bearer " + OAuthService.shared.accessToken]
    }
    
    public var method: Moya.Method {
        return .get
    }
    
    public var task: Task {
        return .requestPlain
    }
}
