//
//  MoyaProvider+Extensions.swift
//  OreosDrib
//
//  Created by P36348 on 31/07/2018.
//  Copyright © 2018 P36348. All rights reserved.
//

import Foundation
import Moya
import RxSwift

extension MoyaProvider {
    public func rx_request(_ token: Target) -> Observable<Response> {
        return self.rx.request(token).asObservable().do(onNext: {res in print(res.debugDescription)})
    }
}
