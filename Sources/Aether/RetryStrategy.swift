//
//  File.swift
//  Aether
//
//  Created by Mohsin Khan on 04/04/25.
//

import Foundation

public enum RetryStrategy {
    /// Never retry — always fail immediately on error.
    case none

    /// Retry using a fixed delay, e.g. linear(2) means 2 seconds every attempt.
    case linear(TimeInterval)

    /// Retry with exponential backoff, e.g. exponential(base: 0.5) doubles each time: 0.5, 1.0, 2.0...
    case exponential(base: TimeInterval)

    /// Custom closure, given the attempt index and returning the delay in seconds.
    case custom((Int) -> TimeInterval)
}
