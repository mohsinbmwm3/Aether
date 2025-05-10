//
//  RetryPolicy.swift
//  Aether
//
//  Created by Mohsin Khan on 04/04/25.
//

import Foundation

public struct RetryPolicy {
    public let maxRetries: Int
    public let strategy: RetryStrategy

    public init(maxRetries: Int, strategy: RetryStrategy) {
        self.maxRetries = maxRetries
        self.strategy = strategy
    }

    /// Returns the delay in **nanoseconds** for the given attempt index
    func delay(for attempt: Int) -> UInt64 {
        let seconds: TimeInterval
        switch strategy {
        case .none:
            seconds = 0
        case .linear(let interval):
            seconds = interval
        case .exponential(let base):
            // 0 -> base, 1 -> base*2, ...
            seconds = base * pow(2.0, Double(attempt))
        case .custom(let closure):
            seconds = closure(attempt)
        }
        // Convert seconds -> nanoseconds
        return UInt64(seconds * 1_000_000_000)
    }
}

extension RetryPolicy {
    
    /// No retries at all.
    public static func none() -> Self {
        .init(maxRetries: 0, strategy: .none)
    }

    /// Retries with a fixed delay (linear backoff).
    public static func linear(maxRetries: Int, interval: TimeInterval) -> Self {
        .init(maxRetries: maxRetries, strategy: .linear(interval))
    }

    /// Retries with exponential backoff (doubles delay each attempt).
    public static func exponential(maxRetries: Int, base: TimeInterval) -> Self {
        .init(maxRetries: maxRetries, strategy: .exponential(base: base))
    }

    /// Custom retry logic using your own delay logic.
    public static func custom(maxRetries: Int, delay: @escaping (Int) -> TimeInterval) -> Self {
        .init(maxRetries: maxRetries, strategy: .custom(delay))
    }
}
