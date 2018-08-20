//
//  MJRefresh+Extension.swift
//  OreosDrib
//
//  Created by P36348 on 13/08/2018.
//  Copyright © 2018 P36348. All rights reserved.
//

import Foundation
import MJRefresh
import RxSwift

private var internal_rx_refreshing_key = "internal_rx_refreshing_key"

extension UIScrollView {
    
    var rx_refreshing: Observable<Bool> {
        return self.internal_rx_refreshing
    }
    
    private var internal_rx_refreshing: PublishSubject<Bool> {
        get {
            guard let item = objc_getAssociatedObject(self, &internal_rx_refreshing_key) as? PublishSubject<Bool> else {
                let item = PublishSubject<Bool>()
                objc_setAssociatedObject(self, &internal_rx_refreshing_key, item, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return item
            }
            return item
        }
    }
    
    
    func rx_pullToRefresh() -> Observable<Void> {
        if self.mj_header == nil {
            self.mj_header = MJRefreshNormalHeader()
        }
        
        return Observable.create({ [weak self] (observer) -> Disposable in
            self?.mj_header.refreshingBlock = {
                self?.internal_rx_refreshing.onNext(true)
                observer.onNext(())
            }
            return Disposables.create()
        }).do(onDispose: { [weak self] in
            self?.mj_header = nil
        })
    }
    func rx_pullToLoadMore() -> Observable<Void> {

        if self.mj_footer == nil {
            self.mj_footer = MJRefreshAutoStateFooter()
        }
        
        return Observable.create({ [weak self] (observer) -> Disposable in
             self?.mj_footer.refreshingBlock = {
                self?.internal_rx_refreshing.onNext(true)
                observer.onNext(())
            }
            return Disposables.create()
        })
            .do(onDispose: { [weak self] in
                self?.mj_footer = nil
            })
    }
    
    func rx_stopLoading() -> Observable<Void> {
        self.stopLoading()
        return Observable.just(())
    }
    
    func stopLoading() {
        if self.mj_header?.isRefreshing == true {
            self.mj_header.endRefreshing()
        }
        if self.mj_footer?.isRefreshing == true {
            self.mj_footer.endRefreshing()
        }
        self.internal_rx_refreshing.onNext(false)
    }
}
