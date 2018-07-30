//
//  AuthorizeAPI.swift
//  OreosDrib
//
//  Created by P36348 on 30/07/2018.
//  Copyright © 2018 P36348. All rights reserved.
//

import Foundation
import Moya

private struct API {
    static let authorize: String = "https://dribbble.com/oauth/dribbble"
    
    static let token: String = "https://dribbble.com/oauth/token"
}

public enum AuthorizeAPI {
    case authorize
    case token(code: String, clientID: String, clientSecret: String)
}


extension AuthorizeAPI: BaseTargetType {
    public var baseURL: URL {
        return URL(string: "https://dribbble.com")!
    }
    public var path: String {
        switch self {
        case .authorize:
            return "/dribbble"
        case .token:
            return "/token"
        }
    }
    public var task: Task {
        switch self {
        case .token(let code, let clientID, let clientSecret):
            return .requestParameters(parameters: ["code": code,
                                                   "client_id": clientID,
                                                   "client_secret": clientSecret],
                                      encoding: Moya.URLEncoding.default)//
        default:
            return .requestPlain
        }
    }
}
