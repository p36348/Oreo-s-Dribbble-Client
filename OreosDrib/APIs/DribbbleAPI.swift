//
//  DribbbleAPI.swift
//  OreosDrib
//
//  Created by P36348 on 29/07/2018.
//  Copyright © 2018 P36348. All rights reserved.
//

import Foundation
import Moya


/// base on v2 dribbble api doc
struct DribbbleAPI {
    static let user: MoyaProvider<UserAPI> = MoyaProvider<UserAPI>()
    
    static let shot: MoyaProvider<ShotAPI> = MoyaProvider<ShotAPI>()
    
    static let authrize: MoyaProvider<AuthorizeAPI> = MoyaProvider<AuthorizeAPI>()
}
