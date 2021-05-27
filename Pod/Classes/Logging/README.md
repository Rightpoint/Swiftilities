# Logging

Set a logging level to dictate priority of events logged

### Quick Start

By default, nothing will be logged, so you want to set a logging level during app set-up, before any loggable events. Different logging levels are often set for different build schemes (debug scheme may be `.verbose` while release might be `.warn`).
```swift
Log.logLevel = .warn
```

Use the level functions when logging to indicate what type of event has occurred
```swift
Log.verbose("Lower priority events will not be logged")
Log.error("Errors are higher priority than .warn, so will be logged")
```

Log levels (from highest to lowest priority):
- verbose
- debug
- info
- warn
- error
- off

When running on iOS 14 or later, log messages will also be reported to OSLog.

## Advanced functionality

You can include one global custom handler that will get called for any string being logged across all Log instances. Assigning another handler will replace the first.

```swift
Log.globalHandler = { (log, level, string) in
    sendToAnalytics((key: level, string: string))
}
```

Log messages may be categorized by defining separate instances of the Log class.

```swift
final class Loggers {
    static let userInterface = Log("UI", logLevel: .verbose)
    static let app = Log("App")
    static let network = Log("Network", logLevel: .error)
}

Loggers.userInterface.info("Button Pressed")
Loggers.network.error("Token Expired")
Loggers.app.warn("Out of Memory")
```

You may also include one custom handler per Log instance. Messages will still be reported to the global handler as well.

```swift
Loggers.network.handler = { (level, string) in
    sendToAnalytics((key: level, string: string))
}
```

Log level can also be represented by emoji instead of strings.

```swift
Log.useEmoji = true
```

Emoji key:
- .verbose = 📖
- .debug = 🐝
- .info = ✏️
- .warn = ⚠️
- .error = ⁉️
