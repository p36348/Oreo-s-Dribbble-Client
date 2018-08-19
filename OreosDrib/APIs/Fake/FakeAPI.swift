//
//  FakeAPI.swift
//  OreosDrib
//
//  Created by P36348 on 14/08/2018.
//  Copyright © 2018 P36348. All rights reserved.
//

import Foundation
import Moya

/// base on v2 dribbble api doc
struct FakeAPI {
    static let shot: MoyaProvider<FakeShotAPI> = MoyaProvider<FakeShotAPI>()
}
