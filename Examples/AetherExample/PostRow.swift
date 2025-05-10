//
//  PostRow.swift
//  Aether
//
//  Created by Mohsin Khan on 11/05/25.
//
import SwiftUI

struct PostRow: View {
    let post: Post
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(post.title)
                .font(.headline)
                .lineLimit(2)
            Text(post.body)
                .font(.subheadline)
                .lineLimit(3)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}

struct FeedbackBanner: View {
    let text: String
    let color: Color

    var body: some View {
        Text(text)
            .padding()
            .background(color.opacity(0.9))
            .cornerRadius(8)
            .foregroundColor(.white)
            .transition(.opacity)
            .zIndex(1)
            .padding(.top, 16)
    }
}
