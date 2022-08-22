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

    /// Test that error handling works correctly
    func testLoadingBadDataHandledCorrectly() throws {
        // Check for internet
        try XCTSkipUnless(Reachability().isReachable, "Network connectivity needed for this test.")

        // Create the promise
        let promise = expectation(description: "Error handled as expected")
        var errorMessage: CustomError?

        // Try to fetch a specific rule
        ruleController.fetchRule(withIndex: "spellcasting", andURL: "/api/rules/spellcasting/BAD-URL") { result in
            switch result {
            case .success: XCTFail("Data returned for some reason??")
            case let .failure(error): errorMessage = error
            }

            promise.fulfill()
        }

        // Wait for the results
        wait(for: [promise], timeout: 2)
        XCTAssertNotNil(errorMessage)
    }

    /// Test that loading a specific rule works correctly
    func testLoadingSpecificRuleWorks() throws {
        // Check for internet
        try XCTSkipUnless(Reachability().isReachable, "Network connectivity needed for this test.")

        // Create the promise
        let promise = expectation(description: "Output as expected")
        var errorMessage: CustomError?

        // Try to fetch a specific rule
        ruleController.fetchRule(withIndex: "spellcasting", andURL: "/api/rules/spellcasting") { result in
            switch result {
            case let .success(rule):
                XCTAssert(rule?.name == "Spellcasting")
                XCTAssert(rule?.index == "spellcasting")
                XCTAssert(rule?.subsections?.isEmpty != true)
            case let .failure(error): errorMessage = error
            }

            promise.fulfill()
        }

        // Wait for the results
        wait(for: [promise], timeout: 2)
        XCTAssertNil(errorMessage)
    }
}
