//
//  File.swift
//  Aether
//
//  Created by Mohsin Khan on 03/04/25.
//

import Foundation

public struct Endpoint {
    public let path: String
    public let method: HTTPMethod
    public let queryItems: [URLQueryItem]?
    public let body: RequestBody?
    public let headers: [String: String]?

    public init(path: String,
                method: HTTPMethod = .get,
                queryItems: [URLQueryItem]? = nil,
                body: RequestBody? = nil,
                headers: [String: String]? = nil) {
        self.path = path
        self.method = method
        self.queryItems = queryItems
        self.body = body
        self.headers = headers
    }
}
