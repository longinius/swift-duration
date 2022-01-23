# Swift ISO 8601 Duration

![](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-orange?style=flat&color=F05138)

An ISO 8601 Duration parser for Swift. Inspired by the [Luxon](https://moment.github.io/luxon) duration object.


## Features

* Parses ISO 8601 formatted duration strings (e.g. "P1D" or "PT1H15M").
* Supports `Codable` protocol.
* Works with negative durations.
* Create a `DateComponents` object from `Duration`.
* Extensions for `Calendar` to use `Duration` like `DateComponents`.

## Usage

```swift
let duration = Duration(fromIso: "P2Y4M12DT5H34M48S")

// Duration contains the parsed values
duration.years // 2
duration.months // 4
duration.days // 12
duration.hours // 5
duration.minutes // 34
duration.seconds // 48

// Create `DateComponents` object from `Duration`
let dateComponents = duration.dateComponents
```


## Installation

The [Swift Package Manager](https://www.swift.org/package-manager/) is a tool for managing the distribution of Swift Code. It's integrated into the `swift` compiler. 

To use `Duration`, simply add the following Package as dependency:
```
https://github.com/longinius/duration.git
```