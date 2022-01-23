//
//  Calendar+Duration.swift
//  
//
//  Created by Lars on 23.01.22.
//

import Foundation

public extension Calendar {

    /// Returns a new Date representing the date calculated by adding the duration to a given date.
    /// - Parameters:
    ///   - duration: A duration.
    ///   - date: The starting date.
    ///   - wrappingComponents: If `true`, the component should be incremented and wrap around to zero/one on overflow, and should not cause higher components to be incremented. The default value is `false`.
    /// - Returns: A new date, or nil if a date could not be calculated with the given input.
    public func date(byAdding duration: Duration, to date: Date, wrappingComponents: Bool = false) -> Date? {
        return self.date(byAdding: duration.toDateComponents(), to: date, wrappingComponents: wrappingComponents)
    }

    /// Returns a new Date representing the date calculated by subtracting the duration to a given date.
    /// - Parameters:
    ///   - duration: A duration.
    ///   - date: The starting date.
    ///   - wrappingComponents: If `true`, the component should be incremented and wrap around to zero/one on overflow, and should not cause higher components to be incremented. The default value is `false`.
    /// - Returns: A new date, or nil if a date could not be calculated with the given input.
    public func date(bySubtracting duration: Duration, to date: Date, wrappingComponents: Bool = false) -> Date? {
        return self.date(byAdding: duration.inverted().toDateComponents(), to: date, wrappingComponents: wrappingComponents)
    }

}
