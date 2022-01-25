//
//  File.swift
//  
//
//  Created by Lars on 23.01.22.
//

import Foundation

/// `DurationError` is the error type returned by `Duration`.
public enum DurationError: Error {
    /// The provided string could not be parsed as `Duration`.  Valid formats are `PnYnMnDTnHnMnS` or `PnW`.
    case parsingError
}
