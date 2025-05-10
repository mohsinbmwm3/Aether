//
//  File.swift
//  Aether
//
//  Created by Mohsin Khan on 04/04/25.
//

import Foundation

/// A simple interceptor for request adaptation and retry decisions.
public protocol RequestInterceptor {
    /// Allows you to modify the request before sending.
    func adapt(_ request: URLRequest) async throws -> URLRequest

    /// Called after a request fails. Decide whether to retry.
    /// - Parameters:
    ///   - request: The request that failed.
    ///   - error: The error that occurred.
    ///   - attempt: The current retry attempt count.
    /// - Returns: `true` if the request should be retried, `false` otherwise.
    func retry(_ request: URLRequest, dueTo error: Error, attempt: Int) async throws -> Bool
}
