//
//  File.swift
//  Aether
//
//  Created by Mohsin Khan on 03/04/25.
//

import Foundation

public protocol APIClientProtocol {
    func request<T: Decodable>(_ endpoint: Endpoint, as type: T.Type) async throws -> T
}

public final class APIClient: APIClientProtocol, @unchecked Sendable {
    private let baseURL: URL
    private let urlSession: URLSession
    private let interceptors: [RequestInterceptor]
    private let observers: [ResponseObserver]

    public init(baseURL: URL,
                session: URLSession = .shared,
                interceptors: [RequestInterceptor] = [],
                observers: [ResponseObserver] = []) {
        self.baseURL = baseURL
        self.urlSession = session
        self.interceptors = interceptors
        self.observers = observers
    }

    public func request<T: Decodable>(
        _ endpoint: Endpoint,
        as type: T.Type
    ) async throws -> T {
        var attempt = 0
        while true {
            do {
                // 1) Build URL + request
                var url = baseURL.appendingPathComponent(endpoint.path)
                if let queryItems = endpoint.queryItems,
                   var components = URLComponents(url: url, resolvingAgainstBaseURL: false) {
                    components.queryItems = queryItems
                    if let newURL = components.url {
                        url = newURL
                    }
                }

                var request = URLRequest(url: url)
                request.httpMethod = endpoint.method.rawValue

                // 2) Add the POST body if any
                if let body = endpoint.body {
                    switch body {
                    case .none:
                        break
                    case .data(let data):
                        request.httpBody = data
                        // If you want to default to "application/octet-stream", you could do:
                        // request.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
                        
                    case .jsonEncodable(let encodable):
                        let encoded = try JSONEncoder().encode(AnyEncodable(encodable))
                        request.httpBody = encoded
                        // Typically you'd set "application/json" if not already set:
                        if request.value(forHTTPHeaderField: "Content-Type") == nil {
                            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                        }
                    }
                }
                
                // 3) Add the POST body if any
                if let headers = endpoint.headers {
                    for (key, value) in headers {
                        request.setValue(value, forHTTPHeaderField: key)
                    }
                }
                
                // 4) Let interceptors adapt the request
                for interceptor in interceptors {
                    request = try await interceptor.adapt(request)
                }

                // 5) Execute request
                let (data, response) = try await urlSession.data(for: request)
                
                // 6) Validate response
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NetworkError.invalidResponse
                }
                
                for observer in observers {
                    observer.didReceive(response: httpResponse, data: data, for: request)
                }
                
                guard (200..<300).contains(httpResponse.statusCode) else {
                    throw NetworkError.serverError(statusCode: httpResponse.statusCode)
                }

                // 7) Decode
                do {
                    let decoded = try JSONDecoder().decode(T.self, from: data)
                    // If success, break out of the loop.
                    return decoded
                } catch {
                    throw NetworkError.decodingFailed(underlying: error)
                }
            } catch {
                // 8) Retry logic: ask interceptors
                var shouldRetry = false
                for interceptor in interceptors {
                    let decision = try await interceptor.retry(
                        // You might keep the original request if needed
                        URLRequest(url: baseURL),
                        dueTo: error,
                        attempt: attempt
                    )
                    if decision {
                        shouldRetry = true
                        break
                    }
                }

                if shouldRetry {
                    attempt += 1
                    continue
                } else {
                    throw error
                }
            }
        }
    }
}
