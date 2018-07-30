//
//  Moya+JSON.swift
//  OreosDrib
//
//  Created by P36348 on 30/07/2018.
//  Copyright © 2018 P36348. All rights reserved.
//

import Foundation
import SwiftyJSON
import Moya
import RxSwift

extension Response {
    public var rx_jsonValue: Observable<JSON> {
        guard
            let json = try? JSON(data: self.data)
            else
        {return Observable.error(NSError(domain: "", code: 0, userInfo: nil))}
        
        return Observable.just(json)
    }
    
    public var jsonValue: JSON? {
        guard
            let json = try? JSON(data: self.data)
            else
        {return nil}
        
        return json
    }
}
