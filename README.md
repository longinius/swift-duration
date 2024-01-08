# Swift ISO 8601 Duration

![](https://img.shields.io/badge/Swift-5.9-orange?style=flat&color=F05138)
![](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-orange?style=flat&color=F05138)
![](https://img.shields.io/badge/Platform-iOS%20macOS%20tvOS%20watchOS-green?style=flat)

An ISO 8601 Duration parser for Swift. Inspired by the [Luxon](https://moment.github.io/luxon) [Duration](https://moment.github.io/luxon/#/tour?id=durations) object.


## Features

* Parses ISO 8601 formatted duration strings (e.g. "P1D" or "PT1H15M").
* Supports `Codable` protocol.
* Works with negative durations.
* Create a `DateComponents` object from `Duration`.
* Extensions for `Calendar` to use `Duration` like `DateComponents`.

## Usage

Create a duration from an ISO 8601 string.
```swift
let duration = Duration(fromISO: "P2Y4M12DT5H34M48S")

// Duration contains the parsed values
duration.year // 2
duration.month // 4
duration.day // 12
duration.hour // 5
duration.minute // 34
duration.second // 48
```

Get a `DateComponents` object from duration.
```swift
let dateComponents = duration.dateComponents
```


## Installation

The [Swift Package Manager](https://www.swift.org/package-manager/) is a tool for managing the distribution of Swift Code. It's integrated into the `swift` compiler. 

To use `Duration` in your project, simply add this Package as dependency:
```swift
dependencies: [
    .package(url: "https://github.com/longinius/swift-duration.git", .upToNextMajor(from: "1.0.0"))
]
```
