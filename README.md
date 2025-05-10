# Aether

> 🌐 Elegant, modular, and fully Swift-concurrency-native networking library for iOS, macOS, and beyond.

Aether is a lightweight Swift networking toolkit designed to be both ergonomic and extensible. Built on top of `URLSession`, it adds powerful features like retry strategies, interceptors, and response observers — without hiding the underlying control.


## ✨ Features

- ✅ `async/await`-ready APIClient
- ✅ Request interceptors (e.g. logging, authentication)
- ✅ Retry policies with linear, exponential, or custom delays
- ✅ Pluggable response observers for analytics/logging
- ✅ Full SwiftUI demo with POST/GET/refresh simulation
- ✅ Compatible with iOS 14+ / macOS 11+
- ✅ Fully modular via Swift Package Manager

## 📦 Installation (Swift Package Manager)

Add the package to your Xcode project:
https://github.com/mohsinbmwm3/aether

## 🧱 Usage Example

```swift
let client = APIClient(
    baseURL: URL(string: "https://jsonplaceholder.typicode.com")!,
    interceptors: [
        LoggingInterceptor(),
        RetryInterceptor(
            policy: .exponential(maxRetries: 3, base: 0.5)
        )
    ],
    observers: [
        ConsoleLoggerObserver()
    ]
)

let endpoint = Endpoint(path: "posts")
let posts: [Post] = try await client.request(endpoint, as: [Post].self)
```

## 🔄 Retry Strategies
```swift
RetryPolicy.linear(maxRetries: 3, interval: 2.0)
RetryPolicy.exponential(maxRetries: 3, base: 0.5)
RetryPolicy.custom(maxRetries: 5) { attempt in
    1 + Double(attempt) * 0.25
}
```

## 📲 Demo App
Check out the included SwiftUI demo under Examples/AetherExample:

- Browse posts (GET)
- Create dummy post (POST)
- Simulate API failures for retry testing
- Works on macOS and iOS simulators

## 🔧 Extending
- Add custom interceptors by conforming to RequestInterceptor
- Add logging/analytics by conforming to ResponseObserver
- Drop into any UIKit/SwiftUI app with minimal setup

## 🛡️ Compatibility
Platform	Minimum Version
- iOS	14
- macOS	11
- tvOS	14
- watchOS	7

## 📄 License
MIT License — free for personal and commercial use.
