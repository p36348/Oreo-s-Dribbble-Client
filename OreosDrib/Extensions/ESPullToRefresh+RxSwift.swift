//
//  ESPullToRefresh+RxSwift.swift
//  OreosDrib
//
//  Created by P36348 on 13/08/2018.
//  Copyright © 2018 P36348. All rights reserved.
//

import Foundation
import RxSwift

extension UIScrollView {
    func rx_pullToRefresh() -> Observable<UIScrollView> {
        return Observable.create({ [weak self] (observer) -> Disposable in
            self?.es.addPullToRefresh {
                if let _self = self {
                    observer.onNext(_self)
                }else {
                    observer.onError(NSError(domain: "", code: 0, userInfo: nil))
                }
            }
            return Disposables.create()
        })
        
    }
}
