//
//  DurationCodableTests.swift
//  
//
//  Created by Lars on 23.01.22.
//

import XCTest
@testable import Duration

class DurationCodableTests: XCTestCase {

    func testCodable() throws {
        let duration = try Duration(fromISO: "P1Y2M3DT4H5M6S")

        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        let data = try encoder.encode(duration)
        let decodedDuration = try decoder.decode(Duration.self, from: data)

        XCTAssertEqual(duration, decodedDuration)
    }

}
