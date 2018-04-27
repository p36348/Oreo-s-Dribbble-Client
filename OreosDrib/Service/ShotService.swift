//
//  ShotService.swift
//  OreosDrib
//
//  Created by P36348 on 7/6/2017.
//  Copyright © 2017 P36348. All rights reserved.
//

import Foundation
import SwiftyJSON
import RxSwift
import Alamofire

/// 接口 -http://developer.dribbble.com/v1/shots/
private struct API {
    
    static let list: String = "/shots".dribbbleFullUrl
    
    static let singleShot: String = "/shots/:id".dribbbleFullUrl
    
    static let show: String = "/shot".dribbbleFullUrl
}

struct ShotService {
    
    static var shared: ShotService = ShotService()
    
    static var shotsVMThread: Thread = {
        
        let _thread: Thread = Thread(block: {
            Thread.current.name = "ShotService.viewModel"
            
            let _runLoop = RunLoop.current
            
            _runLoop.add(NSMachPort(), forMode: RunLoopMode.defaultRunLoopMode)
            
            _runLoop.run()
        })
        
        _thread.start()
        
        return _thread
    }()
    
    var shotOperationQueue: OperationQueue = {
        let _queue = OperationQueue()
        
        _queue.maxConcurrentOperationCount = 1
        
        return _queue
    }()
    
    var shotDispatchQueue: DispatchQueue = {
        return DispatchQueue(label: "ShotService.shot")
    }()
    
    public fileprivate(set) var (shotListSignal, shotListObserver) = Signal<(page: Int, shots: [Shot]), ReactiveError>.pipe()
    
    public fileprivate(set) var shots: [Shot] = []
    
    public fileprivate(set) var shotsViewModels: [ShotCell.ViewModel] = []
    
    private init(){}
    
    private let dateFormatter: DateFormatter = {
        let _formatter: DateFormatter = DateFormatter()
        
        /**
         * 根据dribbble要求格式化
         */
        _formatter.dateFormat = "YYYY-MM-dd"
        
        /**
         * 时区转换为西四区
         */
        _formatter.timeZone = TimeZone(secondsFromGMT: -4 * 60 * 60)
        return _formatter
    }()
    
    
    func getList(page: Int = 1, list: ShotService.List, timeframe: Timeframe, sort: Sort, date: Date) -> NetworkResponse {
        
        let _parameters: Parameters = ["date": dateFormatter.string(from: date),
                                       "sort": sort.rawValue,
                                       "page": page,
                                       "list": list.rawValue,
                                       "timeframe": timeframe.rawValue]
        
        let response = ReactiveNetwork.shared.get(url: API.list, parameters: _parameters)
        
        response.signal.observeResult { (result) in
            self.shotDispatchQueue.async {
                if let _error = result.error {
                    return DispatchQueue.main.async {
                        self.shotListObserver.send(error: _error)
                    }
                }
                
                if let _value = result.value {
                    
                    let (_shots, _cellViewModels) = shotData(with: _value.arrayValue)
                    
                    if page == 1 {
                        self.cacheFirstPage(json: _value)
                    }
                    
                    DispatchQueue.main.async {
                        
                        ShotService.shared.shots = page == 1 ? _shots : ShotService.shared.shots + _shots
                        
                        ShotService.shared.shotsViewModels = page == 1 ? _cellViewModels : ShotService.shared.shotsViewModels + _cellViewModels

                        self.shotListObserver.send(value: (page: page, shots: _shots)) }
                    }
                    
            }
        }
        
        return response
    }
}

private func shotData(with array: [JSON]) -> (shots: [Shot], cellViewModels: [ShotCell.ViewModel]){
    let _shots = array.map { (_json) -> Shot in
        Shot(with: _json)
    }
    
    let _cellViewModels = _shots.map({ (_shot) -> ShotCell.ViewModel in
        return ShotCell.ViewModel(width: (kScreenWidth - 30) / 2, shot: _shot)
    })
    
    return (_shots, _cellViewModels)
}


// MARK: - File manage
extension ShotService {
    
    private var jsonFileName: String { return "shot_list.json"}
    
    func loadCache(completion: @escaping () -> Void) {
        FileService.shared.searchCache(fileName: jsonFileName) { (data, error) in
            DispatchQueue.main.async {
                guard let _data = data else { return completion() }
                
                let json = JSON.init(data: _data)
                
                let result = shotData(with: json.arrayValue)
                
                ShotService.shared.shots = result.shots
                
                ShotService.shared.shotsViewModels = result.cellViewModels
                
                completion()
            }
        }
    }
    
    func cacheFirstPage(json: JSON) {
        FileService.shared.creat(json: json, fileName: jsonFileName) { (error) in
            
        }
    }
}

extension ShotService {
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

extension String {
    fileprivate func replace(id: String) -> String {
        return self.replacingOccurrences(of: ":id", with: id)
    }
}
