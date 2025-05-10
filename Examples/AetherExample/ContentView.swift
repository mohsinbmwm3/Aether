//
//  ContentView.swift
//  Aether
//
//  Created by Mohsin Khan on 10/05/25.
//

import SwiftUI
import Aether

struct NewPost: Encodable {
    let title: String
    let body: String
    let userId: Int
}

struct ContentView: View {
    @State private var posts: [Post] = []
    @State private var selectedPost: Post?
    @State private var errorMessage: String?
    @State private var successMessage: String?
    @State private var loading = false
    @State private var simulateServerError = false

    private let client = APIClient(
        baseURL: URL(string: "https://jsonplaceholder.typicode.com")!,
        interceptors: [
            LoggingInterceptor(isVerbose: true),
            RetryInterceptor(policy: .init(maxRetries: 3, strategy: .exponential(base: 0.5)))
        ],
        observers: [
            ConsoleLoggerObserver()
        ]
    )

    var body: some View {
        NavigationView {
            VStack(spacing: 8) {
                HStack {
                    Button("Create Post") {
                        if #available(iOS 15, macOS 12, *) {
                            Task { await createPost() }
                        } else {
                            fetchLegacy()
                        }
                    }

                    Button(simulateServerError ? "Simulating 500" : "Simulate Error") {
                        simulateServerError.toggle()
                    }
                }
                .padding(.horizontal)
                
                Button("Reload") {
                    if #available(iOS 15, macOS 12, *) {
                        Task { await fetch() }
                    } else {
                        fetchLegacy()
                    }
                }
                .padding(.horizontal)
                if #available(iOS 15.0, macOS 12.0, *) {
                    List(posts, selection: $selectedPost) { post in
                        PostRow(post: post)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedPost = post
                            }
                    }
                    .refreshable {
                        await fetch()
                    }
                } else {
                    List(posts, id: \.id) { post in
                        PostRow(post: post)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedPost = post
                            }
                    }
                }
            }
            .navigationTitle("Posts")
            .overlay(
                Group {
                    if let msg = successMessage {
                        FeedbackBanner(text: msg, color: .green)
                    } else if let error = errorMessage {
                        FeedbackBanner(text: "⚠️ \(error)", color: .red)
                    }
                },
                alignment: .top
            )

            if let post = selectedPost {
                PostDetailView(post: post)
            } else {
                Text("Select a post")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .onAppear {
            if #available(iOS 15.0, macOS 12.0, *) {
                Task { await fetch() }
            } else {
                fetchLegacy()
            }
        }
    }

    @MainActor
    private func fetch() async {
        clearMessages()
        loading = true
        defer { loading = false }

        do {
            let path = simulateServerError ? "fail" : "posts"
            let endpoint = Endpoint(path: path, method: .get)
            posts = try await client.request(endpoint, as: [Post].self)
            selectedPost = posts.first
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    @MainActor
    private func createPost() async {
        clearMessages()
        let newPost = NewPost(title: "Test Post", body: "Created via Aether!", userId: 1)
        let path = simulateServerError ? "fail" : "posts"
        let endpoint = Endpoint(path: path, method: .post, body: .jsonEncodable(newPost))

        do {
            let created = try await client.request(endpoint, as: Post.self)
            posts.insert(created, at: 0)
            selectedPost = created
            successMessage = "✅ Post created (ID \(created.id))"
        } catch {
            errorMessage = "Post failed: \(error.localizedDescription)"
        }
    }

    private func fetchLegacy() {
        errorMessage = "This demo requires macOS 12+ or iOS 15+ for async/await"
    }

    private func clearMessages() {
        errorMessage = nil
        successMessage = nil
    }
}
