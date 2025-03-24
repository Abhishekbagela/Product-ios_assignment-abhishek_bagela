//
//  Listing_ProductsUITests.swift
//  Listing-ProductsUITests
//
//  Created by Abhishek Bagela on 11/03/25.
//

import XCTest

final class Listing_ProductsUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        app = XCUIApplication()
        
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testExample() throws {
        // UI tests must launch the application that they test.
        app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    @MainActor
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
