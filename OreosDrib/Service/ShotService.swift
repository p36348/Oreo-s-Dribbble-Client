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
    
    /// singleton
    static var shared: ShotService = ShotService()
    
    // MARK: stores
    
    public fileprivate(set) var shots: [Shot] = [] {
        didSet {
            self.internalShotsPublishSubject.onNext(self.shots)
        }
    }
    
    fileprivate var shotsParams: ShotsParams = ShotsParams()
    
    public fileprivate(set) var popShots: [Shot] = [] {
        didSet {
            self.internalPopShotsPublishSubject.onNext(self.popShots)
        }
    }
    
    fileprivate var popShotsParams: ShotsParams = ShotsParams()
    
    public fileprivate(set) var detailShot: Shot? = nil
    
    // observables
    
    public var rx_shots: Observable<[Shot]> {
        return self.internalShotsPublishSubject
    }
    
    fileprivate let internalShotsPublishSubject = PublishSubject<[Shot]>()
    
    public var rx_popShots: Observable<[Shot]> {
        return self.internalPopShotsPublishSubject
    }
    
    fileprivate let internalPopShotsPublishSubject = PublishSubject<[Shot]>()
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
            FakeAPI.shot
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
        var params = self.shotsParams
        params.page = 1
        return
            self.fetchShots(page: params.page, pageSize: params.pageSize)
                .map { [unowned self] in self.shots = $0; self.shotsParams = params; return self }
    }
    
    func loadMoreShots() -> Observable<ShotService> {
        var params = self.shotsParams
        params.page += 1
        return
            self.fetchShots(page: params.page, pageSize: params.pageSize)
                .map { [unowned self] in self.shots = self.shots + $0; self.shotsParams = params; return self }
    }
    
    func reloadPopShots() -> Observable<ShotService> {
        var params = self.popShotsParams
        params.page = 1
        return
            self.fetchPopShots(page: params.page, pageSize: params.pageSize)
                .map { [unowned self] in self.popShots = $0; self.popShotsParams = params; return self }
    }
    
    func loadMorePopShots() -> Observable<ShotService> {
        var params = self.popShotsParams
        params.page += 1
        return
            self.fetchPopShots(page: params.page, pageSize: params.pageSize)
                .map { [unowned self] in
                    if $0.count != 0 {self.popShots = self.popShots + $0; self.popShotsParams = params;}
                    return self
        }
    }
    
    func reloadShotDetail() {
        
    }
}

