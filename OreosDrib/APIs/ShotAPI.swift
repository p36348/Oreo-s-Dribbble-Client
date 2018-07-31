//
//  ShotAPI.swift
//  OreosDrib
//
//  Created by P36348 on 30/07/2018.
//  Copyright © 2018 P36348. All rights reserved.
//

import Foundation
import Moya

// MARK: http://developer.dribbble.com/v2/shots/

enum ShotAPI {
    case shots(page: UInt, pageSize: UInt)
    case popularShots(page: UInt, pageSize: UInt)
    case singleShot(id: String)
    case createShot(title: String, image: Data, desc: String?, tags: [String]?, teamID: Int?, reboundSourceID: Int?, lowProfile: Int?)
}

extension ShotAPI: BaseTargetType {
    var path: String {
        switch self {
        case .createShot:
            return "/shots"
        case .shots:
            return "/user/shots"
        case .singleShot(let id):
            return "/shots/\(id)"
        case .popularShots:
            return "/popular_shots"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createShot:
            return .post
        default:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .shots(let page, let pageSize):
            
            return .requestParameters(parameters: ["page": page, "per_page": pageSize], encoding: Moya.URLEncoding.default)
            
        case .createShot(let title, let image, let desc, let tags, let teamID, let reboundSourceID, let lowProfile):
            var parameters: [String: Any] = ["title": title, "image": image]
            
            if let val = desc {parameters["description"] = val}
            if let val = tags {parameters["tags"] = val}
            if let val = teamID {parameters["team_id"] = val}
            if let val = reboundSourceID {parameters["rebound_source_id"] = val}
            if let val = lowProfile {parameters["low_profile"] = val}
            
            return .requestParameters(parameters: parameters,  encoding: Moya.URLEncoding.default)
        default:
            return .requestPlain
        }
    }
}
