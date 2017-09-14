//
//  OreosDribTests.swift
//  OreosDribTests
//
//  Created by P36348 on 8/9/2017.
//  Copyright © 2017 P36348. All rights reserved.
//

import XCTest

class OreosDribTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            FileService.shared.creat(image: UIImage(), fileName: "image.png", completion: { (error) in
                XCTAssertNotNil(error)
            })
        }
    }
    
    func testRequest() {
        ReactiveNetwork.shared.get(url: "https://www.google.com/hk").signal.observeResult { (result) in
            print(result.value ?? "No value")
            
            XCTAssertNotNil(result.value)
        }
    }
    
    func testShotRequest() {
        ShotService.shared.getList(list: ShotService.List.all, timeframe: ShotService.Timeframe.ever, sort: ShotService.Sort.recent, date: Date()).signal.observeResult { (result) in

            XCTAssert(result.value != nil && result.value?.arrayValue.isEmpty == false)
        }
    }
    
}
