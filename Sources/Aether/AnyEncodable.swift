//
//  AnyEncodable.swift
//  Aether
//
//  Created by Mohsin Khan on 04/04/25.
//

import Foundation

/// A type-erased Encodable, allowing you to store any Encodable
/// without generics in your struct or enum.
struct AnyEncodable: Encodable {
    private let encodable: Encodable
    
    init(_ encodable: Encodable) {
        self.encodable = encodable
    }

    func encode(to encoder: Encoder) throws {
        try encodable.encode(to: encoder)
    }
}
