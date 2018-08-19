//
//  Optional+RxSwift.swift
//  ThinkerBaseKit
//
//  Created by P36348 on 26/06/2018.
//  Copyright © 2018 P36348. All rights reserved.
//

import Foundation
import RxSwift

extension Optional {
    public func skipNil() -> Observable<Wrapped> {
        switch self {
        case .none:
            return Observable.error(NSError(domain: "引用指针已经为空, 请检查代码", code: 0, userInfo: nil))
        case .some(let wrapped):
            return Observable.just(wrapped)
        }
    }
}
