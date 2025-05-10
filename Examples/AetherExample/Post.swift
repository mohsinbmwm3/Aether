//
//  Post.swift
//  Aether
//
//  Created by Mohsin Khan on 10/05/25.
//

struct Post: Codable, Identifiable, Hashable {
    let id: Int
    let title: String
    let body: String
}
