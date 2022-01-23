//
//  Parser.swift
//  
//
//  Created by Lars on 23.01.22.
//

import Foundation

internal class Parser {

    internal typealias DurationObject = [Duration.Component: Int]

    // swiftlint:disable:next force_try line_length
    private static let isoDuration = try! NSRegularExpression(pattern: "^-?P(?:(?:(?<year>-?\\d{1,9}(?:.\\d{1,9})?)Y)?(?:(?<month>-?\\d{1,9}(?:.\\d{1,9})?)M)?(?:(?<week>-?\\d{1,9}(?:.\\d{1,9})?)W)?(?:(?<day>-?\\d{1,9}(?:.\\d{1,9})?)D)?(?:T(?:(?<hour>-?\\d{1,9}(?:.\\d{1,9})?)H)?(?:(?<minute>-?\\d{1,9}(?:.\\d{1,9})?)M)?(?:(?<second>-?\\d{1,20})(?:[.,](?<millisecond>-?\\d{1,9}))?S)?)?)$")

    internal static func extractISODuration(from string: String) throws -> DurationObject {
        let range = NSRange(string.startIndex..<string.endIndex, in: string)
        let matches = Self.isoDuration.matches(in: string, options: [], range: range)

        guard let match = matches.first else {
            throw DurationError.parsingError
        }

        var captures: [Duration.Component: Substring] = [:]
        for name in Duration.Component.allCases {
            let matchRange = match.range(withName: name.rawValue)

            if let substringRange = Range(matchRange, in: string) {
                captures[name] = string[substringRange]
            }
        }

        let hasNegativePrefix = string.first == "-"
        let hasNegativeSeconds: Bool = captures[.second]?.first == "-"
        let hasNegativeMilliseconds = (hasNegativePrefix && !hasNegativeSeconds) || (!hasNegativePrefix && hasNegativeSeconds)

        var durationObject: DurationObject = [:]

        for capture in captures {
            if capture.key == .millisecond {
                durationObject[capture.key] = parseMillis(from: capture.value, negate: hasNegativeMilliseconds)
            } else {
                durationObject[capture.key] = parseInt(from: capture.value, negate: hasNegativePrefix)
            }
        }

        return durationObject
    }

    private static func parseInt(from substring: Substring?, negate: Bool = false) -> Int? {
        guard let string = substring, let value = Int(string) else {
            return nil
        }

        return negate ? -value : value
    }

    private static func parseMillis(from substring: Substring?, negate: Bool = false) -> Int? {
        guard let string = substring, let value = Double("0.\(string)") else {
            return nil
        }

        let millis = Int(value * 1000)
        return negate ? -millis : millis
    }

}
