//
//  DurationTests.swift
//
//
//  Created by Lars on 23.01.22.
//

import XCTest
@testable import Duration

final class DurationTests: XCTestCase {

    func testCanParseISODuration() {
        XCTAssertEqual(
            try Duration(fromISO: "P5Y2M"),
            Duration(year: 5, month: 2)
        )
        XCTAssertEqual(
            try Duration(fromISO: "P2M7W"),
            Duration(month: 2, week: 7)
        )
        XCTAssertEqual(
            try Duration(fromISO: "P4W1DT12H54M"),
            Duration(week: 4, day: 1, hour: 12, minute: 54)
        )
        XCTAssertEqual(
            try Duration(fromISO: "PT12H4M"),
            Duration(hour: 12, minute: 4)
        )
        XCTAssertEqual(
            try Duration(fromISO: "PT7M3600S"),
            Duration(minute: 7, second: 3600)
        )
        XCTAssertEqual(
            try Duration(fromISO: "PT1000000000000000000.999S"),
            Duration(second: 1000000000000000000, millisecond: 999)
        )
    }

    func testCanParseNegativeAndMixedISODuration() {
        XCTAssertEqual(
            try Duration(fromISO: "-P5Y2M"),
            Duration(year: -5, month: -2)
        )
        XCTAssertEqual(
            try Duration(fromISO: "-P2M7W"),
            Duration(month: -2, week: -7)
        )
        XCTAssertEqual(
            try Duration(fromISO: "P-4W1DT12H54M"),
            Duration(week: -4, day: 1, hour: 12, minute: 54)
        )
        XCTAssertEqual(
            try Duration(fromISO: "-P-5Y-3D"),
            Duration(year: 5, day: 3)
        )
        XCTAssertEqual(
            try Duration(fromISO: "PT-1.5S"),
            Duration(second: -1, millisecond: -500)
        )
        XCTAssertEqual(
            try Duration(fromISO: "-PT1.5S"),
            Duration(second: -1, millisecond: -500)
        )
        XCTAssertEqual(
            try Duration(fromISO: "PT-0.5S"),
            Duration(second: 0, millisecond: -500)
        )
        XCTAssertEqual(
            try Duration(fromISO: "PT0.5S"),
            Duration(second: 0, millisecond: 500)
        )
        XCTAssertEqual(
            try Duration(fromISO: "-PT-1.5S"),
            Duration(second: 1, millisecond: 500)
        )
        XCTAssertEqual(
            try Duration(fromISO: "P-2W"),
            Duration(week: -2)
        )
    }

    func testDurationFromISORejectsInvalid() {
        XCTAssertThrowsError(try Duration(fromISO: "test"))
        XCTAssertThrowsError(try Duration(fromISO: "PT1blob"))
        XCTAssertThrowsError(try Duration(fromISO: "P3Y54S"))
        XCTAssertThrowsError(try Duration(fromISO: "3Y"))
        XCTAssertThrowsError(try Duration(fromISO: "T54S"))
    }

    func testDateComponents() {
        let duration = Duration(year: 1, month: 2, week: 3, day: 4, hour: 5, minute: 6, second: 7, millisecond: 8)
        let dateComponents = DateComponents(year: 1, month: 2, day: 25, hour: 5, minute: 6, second: 7, nanosecond: 8_000_000)
        XCTAssertEqual(duration.dateComponents, dateComponents)
    }

    func testISO8601String() {
        XCTAssertEqual((try Duration(fromISO: "P5Y2M")).iso8601, "P5Y2M")
        XCTAssertEqual((try Duration(fromISO: "P2M7W")).iso8601, "P2M7W")
        XCTAssertEqual((try Duration(fromISO: "P4W1DT12H54M")).iso8601, "P4W1DT12H54M")
        XCTAssertEqual((try Duration(fromISO: "PT7M3600S")).iso8601, "PT7M3600S")
        XCTAssertEqual((try Duration(fromISO: "PT0.5S")).iso8601, "PT0.5S")
        XCTAssertEqual((Duration()).iso8601, "PT0S")
    }

    func testInvertedDuration() {
        let duration = Duration(year: 1, month: 2, week: 3, day: 4, hour: 5, minute: 6, second: 7, millisecond: 8).inverted()
        let inverted = Duration(year: -1, month: -2, week: -3, day: -4, hour: -5, minute: -6, second: -7, millisecond: -8)
        XCTAssertEqual(duration, inverted)
    }
}
