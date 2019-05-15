# Logging

Set a logging level to dictate priority of events logged

### Quick Start

By default, nothing will be logged, so you wan't to set a logging level during app set-up, before any loggable events. Different logging levels are often set for different build schemes (debug scheme may be `.verbose` while release might be `.warn`)
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

## Advanced functionality

You can include one custom handler that will get called for any string being logged. Assigning another handler will replace the first.

```swift
Log.handler = { (level, string) in
    sendToAnalytics((key: level, string: string))
}
```

Log level can also be represented by emoji instead of strings.

```swift
Log.useEmoji = true
```
