//
//  File.swift
//  Aether
//
//  Created by Mohsin Khan on 04/04/25.
//

import Foundation

/// Represents the request body data or an Encodable model.
public enum RequestBody {
    /// No body data (e.g. for GET or simple requests).
    case none
    
    /// Raw Data to send in the body (e.g., for file uploads or custom formats).
    case data(Data)
    
    /// An Encodable object, which we'll encode as JSON by default.
    case jsonEncodable(Encodable)
    
    // You could add more variants if you want specialized behavior, e.g. multipart forms.
}
