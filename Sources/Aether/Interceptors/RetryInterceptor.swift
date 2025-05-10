//
//  File.swift
//  Aether
//
//  Created by Mohsin Khan on 04/04/25.
//

import Foundation

public struct RetryInterceptor: RequestInterceptor {
    private let policy: RetryPolicy

    public init(policy: RetryPolicy) {
        self.policy = policy
    }

    public func adapt(_ request: URLRequest) async throws -> URLRequest {
        // Typically no changes for retry
        return request
    }

    public func retry(_ request: URLRequest,
                      dueTo error: Error,
                      attempt: Int) async throws -> Bool {
        guard attempt < policy.maxRetries else {
            return false
        }

        // Example: only retry if we get a 5xx
        if let netErr = error as? NetworkError {
            switch netErr {
            case .serverError(let code) where (500...599).contains(code):
                // Sleep the required backoff
                let delayNS = policy.delay(for: attempt)
                if delayNS > 0 {
                    try await Task.sleep(nanoseconds: delayNS)
                }
                return true
            default:
                break
            }
        }
        return false
    }
}
