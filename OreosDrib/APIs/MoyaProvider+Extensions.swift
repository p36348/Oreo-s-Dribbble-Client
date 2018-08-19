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
        return self.rx.request(token).asObservable()
            .do(onNext: {
                let string = try $0.mapString()
                print("===> request:", $0.request!, "\n===> response:", $0, "\n===> value:", $0.jsonValue ?? string)
            }, onError: {
                print("recive error", $0)
            })
    }
}
