//
//  ResponseObserver.swift
//  Aether
//
//  Created by Mohsin Khan on 11/05/25.
//

import Foundation

public protocol ResponseObserver: Sendable {
    func didReceive(response: HTTPURLResponse, data: Data, for request: URLRequest)
}
