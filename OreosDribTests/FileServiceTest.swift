//
//  FileServiceTest.swift
//  OreosDrib
//
//  Created by P36348 on 9/8/17.
//  Copyright © 2017 P36348. All rights reserved.
//

import XCTest

class FileServiceTest: XCTestCase {
    func testCache() {
        FileService.shared.creat(json: ["testJson": "I am for testing!"], fileName: "test.json") { (error) in
            print(error.debugDescription)
        }
    }
}
