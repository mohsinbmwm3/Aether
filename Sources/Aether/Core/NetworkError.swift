//
//  File.swift
//  Aether
//
//  Created by Mohsin Khan on 03/04/25.
//

import Foundation

public enum NetworkError: Error {
    case invalidResponse
    case serverError(statusCode: Int)
    case decodingFailed(underlying: Error)
}
