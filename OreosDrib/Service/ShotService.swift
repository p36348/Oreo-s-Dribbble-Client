//
//  ShotService.swift
//  OreosDrib
//
//  Created by P36348 on 7/6/2017.
//  Copyright © 2017 P36348. All rights reserved.
//

import Foundation
import Result
import ReactiveSwift
import Alamofire
/// 接口 -http://developer.dribbble.com/v1/shots/
private struct API {
    
    static let list: String = "/shots".dribbbleFullUrl
    
    static let singleShot: String = "/shots/:id".dribbbleFullUrl
    
    static let show: String = "/shot".dribbbleFullUrl
}

struct ShotService {
    
    static var shared: ShotService = ShotService()
    
    var (shotListSignal, shotListObserver) = Signal<(page: Int, shots: [Shot]), ReactiveError>.pipe()
    
    private init(){}
    
    private let dateFormatter: DateFormatter = {
        let _formatter: DateFormatter = DateFormatter()
        _formatter.dateFormat = "YYYY-MM-dd"
        return _formatter
    }()
    
    
    func getList(list: ShotService.List = .all, timeframe: Timeframe = .ever, sort: Sort = .recent, page: Int = 1, date: Date) -> NetworkResponse {
        
        var _parameters: Parameters = ["date": dateFormatter.string(from: date) ,"sort": sort.rawValue, "page": page]
        
        if list != .all { _parameters["list"] = list.rawValue }
        
        if sort != .recent {_parameters["timeframe"] = timeframe.rawValue}
        
        let response = ReactiveNetwork.shared.get(url: API.list, parameters: _parameters)
        
        response.signal.observeResult { (result) in
            if let _error = result.error { return self.shotListObserver.send(error: _error) }
            
            if let _value = result.value {
                let _shots = _value.arrayValue.map({ (_json) -> Shot in
                    return Shot(with: _json)
                })
                return self.shotListObserver.send(value: (page: page, shots: _shots)) }
        }
        
        return response
    }
}

extension ShotService {
    enum List: String {
        case animated = "animated", attachments = "attachments", debuts = "debuts", playoffs = "playoffs", rebounds = "rebounds", teams = "teams", all = ""
    }
    enum Sort: String {
        case comments = "comments", recent = "recent", views = "views"
    }
    enum Timeframe: String {
        case week = "week", month = "month", year = "year", ever = "ever"
    }
}

extension String {
    fileprivate func replace(id: String) -> String {
        return self.replacingOccurrences(of: ":id", with: id)
    }
}
