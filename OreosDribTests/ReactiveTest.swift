//
//  ReactiveTest.swift
//  OreosDrib
//
//  Created by P36348 on 9/8/17.
//  Copyright © 2017 P36348. All rights reserved.
//

import XCTest

class ReactiveTest: XCTestCase {
    
    func testRequest() {
        ReactiveNetwork.shared.get(url: "https://www.youtube.com").signal.observeResult { (result) in
            print(result.value ?? "No value")
        }
    }
}
