//
//  LiveFrontProjectSlowTests.swift
//  LiveFrontProjectSlowTests
//
//  Created by Shannon Draeker on 8/19/22.
//

import XCTest

@testable import LiveFrontProject

class LiveFrontProjectSlowTests: XCTestCase {
    // MARK: - Set Up

    var ruleController: RuleController!

    override func setUpWithError() throws {
        try super.setUpWithError()
        ruleController = RuleController()
    }

    override func tearDownWithError() throws {
        ruleController = nil
        try super.tearDownWithError()
    }

    // MARK: - Tests

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

    /// Test that loading the list of all the rules works correctly
    func testLoadingRulesWorks() throws {
        // Check for internet
       try XCTSkipUnless(Reachability().isReachable, "Network connectivity needed for this test.")

        // Create the promise
        let promise = expectation(description: "Output as expected")
        var errorMessage: CustomError?

        // Try to fetch the rules
        ruleController.fetchRules { result in
            switch result {
            case .success: break
            case let .failure(error): errorMessage = error
            }

            promise.fulfill()
        }

        // Wait for the results
        wait(for: [promise], timeout: 2)
        XCTAssertNil(errorMessage)
    }
}
