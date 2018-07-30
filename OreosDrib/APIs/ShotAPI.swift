//
//  ShotAPI.swift
//  OreosDrib
//
//  Created by P36348 on 30/07/2018.
//  Copyright © 2018 P36348. All rights reserved.
//

import Foundation
import Moya

enum ShotAPI {
    case shots(page: Int, list: List, timeframe: Timeframe, sort: Sort, date: Date)
    case singleShot(id: String)
    case shot
}

extension ShotAPI {
    enum List: String {
        case animated = "animated", attachments = "attachments", debuts = "debuts", playoffs = "playoffs", rebounds = "rebounds", teams = "teams", all = ""
    }
    enum Sort: String {
        case comments = "comments", recent = "recent", views = "views", popularity = ""
    }
    enum Timeframe: String {
        case week = "week", month = "month", year = "year", ever = "ever", now = ""
    }
}



extension ShotAPI: BaseTargetType {
    var path: String {
        switch self {
        case .shot:
            return "/shot"
        case .shots:
            return "/shots"
        case .singleShot(let id):
            return "/shots/\(id)"
        }
    }
    var task: Task {
        switch self {
        case .shots(let page, let list, let timeframe, let sort, let date):
            return .requestParameters(parameters: ["date": apiDateFormatter.string(from: date),
                                                   "sort": sort.rawValue,
                                                   "page": page,
                                                   "list": list.rawValue,
                                                   "timeframe": timeframe.rawValue],
                                      encoding: Moya.URLEncoding.default)
        default:
            return .requestPlain
        }
    }
}
