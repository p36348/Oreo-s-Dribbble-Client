//
//  OreosDribUITests.swift
//  OreosDribUITests
//
//  Created by P36348 on 6/6/17.
//  Copyright © 2017 P36348. All rights reserved.
//

import XCTest

class OreosDribUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let app = XCUIApplication()
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery.children(matching: .cell).element(boundBy: 4).children(matching: .other).element.swipeUp()
        collectionViewsQuery.children(matching: .cell).element(boundBy: 2).children(matching: .other).element.swipeDown()
        collectionViewsQuery.children(matching: .cell).element(boundBy: 0).children(matching: .other).element.tap()
        app.tables.containing(.activityIndicator, identifier:"Progress halted").element.swipeDown()
        app.navigationBars["OreosDrib.ShotDetail"].children(matching: .button).matching(identifier: "Back").element(boundBy: 0).tap()
        
        
    }
    
}
