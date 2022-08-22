//
//  LiveFrontProjectTests.swift
//  LiveFrontProjectTests
//
//  Created by Shannon Draeker on 8/19/22.
//

import XCTest

@testable import LiveFrontProject

class LiveFrontProjectTests: XCTestCase {
    // MARK: - Set Up

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // MARK: - Tests

    /// Test that decoding the data works correctly
    func testDecodingDataWorks() {
        // A trimmed-down copy of the JSON string returned from the server when fetching all the rules
        let sampleData = """
        {
        \"count\":2,
        \"results\":
            [
                {\"name\":\"Adventuring\",\"index\":\"adventuring\",\"url\":\"/api/rules/adventuring\"},
                {\"name\":\"Appendix\",\"index\":\"appendix\",\"url\":\"/api/rules/appendix\"}
            ]
        }
        """

        // Sample data that will not be able to be decoded, to test error handling
        let badSampleData = "{garbage}"

        // Test decoding the good data
        let tryDecodedObject = try? sampleData.tryToObject(ofType: AllRules.self)
        XCTAssertNotNil(tryDecodedObject)
        XCTAssert(tryDecodedObject?.count == 2)
        XCTAssert(tryDecodedObject?.results?.map(\.index).contains("adventuring") == true)
        let decodedObject = sampleData.toObject(ofType: AllRules.self)
        XCTAssertNotNil(decodedObject)
        XCTAssert(decodedObject?.count == 2)
        XCTAssert(decodedObject?.results?.map(\.index).contains("adventuring") == true)

        // Test decoding the bad data to make sure errors are handled as simply nil
        let tryDecodedBadData = try? badSampleData.tryToObject(ofType: AllRules.self)
        XCTAssertNil(tryDecodedBadData)
        let decodedBadData = badSampleData.toObject(ofType: AllRules.self)
        XCTAssertNil(decodedBadData)
    }
}
