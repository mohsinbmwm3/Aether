//
//  ConsoleLoggerObserver.swift
//  Aether
//
//  Created by Mohsin Khan on 11/05/25.
//

import Foundation

public struct ConsoleLoggerObserver: ResponseObserver {
    public init() {}

    public func didReceive(response: HTTPURLResponse, data: Data, for request: URLRequest) {
        print("[Aether] ⬇️ Response: \(response.statusCode) for \(request.url?.absoluteString ?? "nil")")
        
        if let json = try? JSONSerialization.jsonObject(with: data, options: []),
           let pretty = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
           let str = String(data: pretty, encoding: .utf8) {
            print("[Aether] 📦 Response Body:\n\(str)")
        } else {
            print("[Aether] ⚠️ Raw Response Body: \(String(data: data, encoding: .utf8) ?? "<binary>")")
        }
    }
}
