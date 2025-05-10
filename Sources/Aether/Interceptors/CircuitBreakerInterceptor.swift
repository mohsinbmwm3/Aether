//
//  File.swift
//  Aether
//
//  Created by Mohsin Khan on 04/04/25.
//

import Foundation

public actor CircuitBreakerInterceptor: RequestInterceptor {
    private let failureThreshold: Int
    private let resetTimeout: TimeInterval
    
    private var failureCount = 0
    private var lastFailureTime: Date?
    private var state: BreakerState = .closed

    public init(failureThreshold: Int = 3, resetTimeout: TimeInterval = 10) {
        self.failureThreshold = failureThreshold
        self.resetTimeout = resetTimeout
    }

    public func adapt(_ request: URLRequest) async throws -> URLRequest {
        // If circuit is open, fail immediately
        switch state {
        case .open:
            // If enough time has passed, move to halfOpen
            if let lastFail = lastFailureTime,
               Date().timeIntervalSince(lastFail) > resetTimeout {
                state = .halfOpen
            } else {
                throw NetworkError.serverError(statusCode: 503) // or custom error
            }
        case .halfOpen:
            // We'll allow a single attempt
            break
        case .closed:
            // normal
            break
        }
        return request
    }

    public func retry(_ request: URLRequest,
                      dueTo error: Error,
                      attempt: Int) async throws -> Bool {
        // If the request was successful, we wouldn't be here. So we have a failure.
        // We'll increment our failureCount.
        failureCount += 1
        lastFailureTime = Date()
        
        switch state {
        case .closed, .halfOpen:
            if failureCount >= failureThreshold {
                state = .open
            }
        case .open:
            // Already open
            return false
        }

        // This interceptor won't handle typical retry. Let other interceptors handle it if needed.
        return false
    }

    public func recordSuccess() {
        // In normal usage, call this from your API client on 2xx success
        failureCount = 0
        state = .closed
    }
}

private enum BreakerState {
    case closed
    case halfOpen
    case open
}
