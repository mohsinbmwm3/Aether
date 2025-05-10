//
//  PostDetailView.swift
//  Aether
//
//  Created by Mohsin Khan on 11/05/25.
//

import SwiftUI

struct PostDetailView: View {
    let post: Post

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text(post.title)
                    .font(.title)
                    .bold()
                Text(post.body)
                    .font(.body)
            }
            .padding()
        }
        .navigationTitle("Detail")
    }
}
