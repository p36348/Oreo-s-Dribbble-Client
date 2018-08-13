//
//  ShotService.swift
//  OreosDrib
//
//  Created by P36348 on 7/6/2017.
//  Copyright © 2017 P36348. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import RxSwift
import Moya

struct ShotsParams {
    var page: UInt = 1
    var pageSize: UInt = 30
}

class ShotService {
    
    static var shared: ShotService = ShotService()
    
    // MARK: stores
    
    public fileprivate(set) var shots: [Shot] = [] {
        didSet {
            (self.rx_shots as! PublishSubject).onNext(self.shots)
        }
    }
    
    fileprivate var shotsParams: ShotsParams = ShotsParams()
    
    public fileprivate(set) var popShots: [Shot] = [] {
        didSet {
            (self.rx_popShots as! PublishSubject).onNext(self.popShots)
        }
    }
    
    fileprivate var popShotsParams: ShotsParams = ShotsParams()
    
    public fileprivate(set) var detailShot: Shot? = nil
    
    //    public fileprivate(set) var shotsViewModels: [ShotCell.ViewModel] = []
    
    // observables
    
    public let rx_shots: Observable<[Shot]> = PublishSubject<[Shot]>()
    
    public let rx_popShots: Observable<[Shot]> = PublishSubject<[Shot]>()
    
    public let rx_loading: Observable<Bool> = PublishSubject<Bool>()
    
}

// MARK: - data fetch, no side effect
extension ShotService {
    fileprivate func fetchShots(page: UInt, pageSize: UInt) -> Observable<[Shot]> {
        
        return
            DribbbleAPI.shot
                .rx_request(.shots(page: page, pageSize: pageSize))
                .flatMap {$0.rx_jsonValue}
                .map { mapJsonToShots($0) }
    }
    
    fileprivate func fetchPopShots(page: UInt, pageSize: UInt) -> Observable<[Shot]> {
        
        return
            DribbbleAPI.shot
                .rx_request(.popularShots(page: page, pageSize: pageSize))
                .flatMap {$0.rx_jsonValue}
                .map { mapJsonToShots($0) }
    }
    
    func fetchShotDetail() {
        
    }
}

private func mapJsonToShots(_ json: JSON) -> [Shot] {
    return json.arrayValue.map { Shot(with: $0) }
}

// MARK: - stores update (with side effect) 由于是共享的数据, 需要避免重复调用
extension ShotService {
    
    func reloadShots() -> Observable<ShotService> {
        let params = self.shotsParams
        return
            self.fetchShots(page: params.page, pageSize: params.pageSize)
                .map { [unowned self] in self.shots = $0; return self }
    }
    
    func loadMoreShots() -> Observable<ShotService> {
        var params = self.shotsParams
        params.page += 1
        return
            self.fetchShots(page: params.page, pageSize: params.pageSize)
                .map { [unowned self] in self.shots = self.shots + $0; self.shotsParams = params; return self }
    }
    
    func reloadPopShots() -> Observable<ShotService> {
        let params = self.popShotsParams
        return
            self.fetchPopShots(page: params.page, pageSize: params.pageSize)
                .map { [unowned self] in self.popShots = $0; return self }
    }
    
    func loadMorePopShots() -> Observable<ShotService> {
        var params = self.popShotsParams
        params.page += 1
        return
            self.fetchPopShots(page: params.page, pageSize: params.pageSize)
                .map { [unowned self] in self.popShots = self.popShots + $0; self.popShotsParams = params; return self }
    }
    
    func reloadShotDetail() {
        
    }
}

