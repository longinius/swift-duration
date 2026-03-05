//
//  DurationTests.swift
//
//
//  Created by Lars on 23.01.22.
//

import Foundation
import Testing
@testable import Duration

struct DurationTests {
    @Test func canParseISODuration() {
        let testCases: [String: Duration] = [
            "P5Y2M": Duration(year: 5, month: 2),
            "P2M7W": Duration(month: 2, week: 7),
            "P4W1DT12H54M": Duration(week: 4, day: 1, hour: 12, minute: 54),
            "PT12H4M": Duration(hour: 12, minute: 4),
            "PT7M3600S": Duration(minute: 7, second: 3600),
            "PT1000000000000000000.999S": Duration(second: 1000000000000000000, millisecond: 999000),
        ]
        
        for (input, expected) in testCases {
            #expect(throws: Never.self) {
                try Duration(fromISO: input) == expected
            }
        }
    }

    @Test func canHandleZeroDuration() {
        let testCase = Duration(second: 0)
        #expect(testCase.iso8601 == "PT0S")
    }

    @Test func canParseNegativeAndMixedISODuration() {
        let testCases: [String: Duration] = [
            "-P5Y2M": Duration(year: -5, month: -2),
            "-P2M7W": Duration(month: -2, week: -7),
            "P-4W1DT12H54M": Duration(week: -4, day: 1, hour: 12, minute: 54),
            "-P-5Y-3D": Duration(year: 5, day: 3),
            "PT-1.5S": Duration(second: -1, millisecond: -500),
            "-PT1.5S": Duration(second: -1, millisecond: -500),
            "PT-0.5S": Duration(second: 0, millisecond: -500),
            "PT0.5S": Duration(second: 0, millisecond: 500),
            "-PT-1.5S": Duration(second: 1, millisecond: 500),
            "P-2W": Duration(week: -2),
        ]
        
        for (input, expected) in testCases {
            #expect(throws: Never.self) {
                try Duration(fromISO: input) == expected
            }
        }
    }

    @Test func durationFromISORejectsInvalid() {
        let testCases: [String] = [
            "test",
            "PT1blob",
            "P3Y54S",
            "3Y",
            "T54S"
        ]
        
        for input in testCases {
            #expect(throws: DurationError.parsingError) {
                try Duration(fromISO: input)
            }
        }
    }

    @Test func dateComponents() {
        let duration = Duration(year: 1, month: 2, week: 3, day: 4, hour: 5, minute: 6, second: 7, millisecond: 8)
        let dateComponents = DateComponents(year: 1, month: 2, day: 25, hour: 5, minute: 6, second: 7, nanosecond: 8_000_000)
        #expect(duration.dateComponents == dateComponents)
    }

    @Test func testISO8601String() {
        let testCases: [String] = [
            "P5Y2M",
            "P2M7W",
            "P4W1DT12H54M",
            "PT7M3600S",
            "PT0.5S"
        ]
        
        for input in testCases {
            #expect(throws: Never.self) {
                try Duration(fromISO: input).iso8601 == input
            }
        }
        #expect((Duration()).iso8601 == "PT0S")
    }

    @Test func testInvertedDuration() {
        let duration = Duration(year: 1, month: 2, week: 3, day: 4, hour: 5, minute: 6, second: 7, millisecond: 8).inverted()
        let inverted = Duration(year: -1, month: -2, week: -3, day: -4, hour: -5, minute: -6, second: -7, millisecond: -8)
        #expect(duration == inverted)
    }

    @Test func testValueForAndSetValue() {
        let duration = Duration()

        duration.setValue(1, for: .year)
        duration.setValue(2, for: .month)
        duration.setValue(3, for: .week)
        duration.setValue(4, for: .day)
        duration.setValue(5, for: .hour)
        duration.setValue(6, for: .minute)
        duration.setValue(7, for: .second)
        duration.setValue(8, for: .millisecond)

        #expect(duration.value(for: .year) == 1)
        #expect(duration.value(for: .month) == 2)
        #expect(duration.value(for: .week) == 3)
        #expect(duration.value(for: .day) == 4)
        #expect(duration.value(for: .hour) == 5)
        #expect(duration.value(for: .minute) == 6)
        #expect(duration.value(for: .second) == 7)
        #expect(duration.value(for: .millisecond) == 8)
    }
}
