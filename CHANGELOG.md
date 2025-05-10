# 📦 Aether – Changelog

All notable changes to this project will be documented here.

---

## [v0.1.0] - 2025-05-11

### Added
- APIClient core with async/await support
- Endpoint abstraction and HTTPMethod enum
- RequestInterceptor protocol
  - LoggingInterceptor
  - RetryInterceptor
- RetryPolicy (linear, exponential, custom)
- ResponseObserver protocol
  - ConsoleLoggerObserver
- NetworkError enum for common failures
- SwiftUI demo app for macOS/iOS
  - Create Post, Simulate Error, Manual Reload
  - Compatibility down to iOS 14 / macOS 11
