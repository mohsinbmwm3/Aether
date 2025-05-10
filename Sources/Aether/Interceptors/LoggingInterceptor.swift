//
//  File.swift
//  Aether
//
//  Created by Mohsin Khan on 04/04/25.
//

import Foundation

public struct LoggingInterceptor: RequestInterceptor {
    private let isVerbose: Bool

    public init(isVerbose: Bool = true) {
        self.isVerbose = isVerbose
    }

    public func adapt(_ request: URLRequest) async throws -> URLRequest {
        if isVerbose {
            print("[Aether] Request: \(request.httpMethod ?? "-") \(request.url?.absoluteString ?? "nil")")
        }
        return request
    }

    public func retry(_ request: URLRequest, dueTo error: Error, attempt: Int) async throws -> Bool {
        if isVerbose {
            print("[Aether] Retry Attempt \(attempt): \(error.localizedDescription)")
        }
        return false
    }
}
