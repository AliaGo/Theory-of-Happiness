//
//  PostCellViewBuilder.swift
//  TOH
//
//  Created by Alia on 2025/4/8.
//

import SwiftUI
import SDWebImageSwiftUI

struct PostCellViewBuilder: View {

    let post: Post

    var body: some View {
        PostBlockView(post: post)
    }
}

struct PostBlockView: View {

    let post: Post

    @StateObject private var viewModel = PostViewModel()
    @State private var showComments = false
    @State private var showPostInfo = false

    var body: some View {

        VStack(alignment: .leading, spacing: 12) {

            // MARK: Photo Area (改成手動 navigation)

            WebImage(
                url: URL(string: post.postPhotoPathUrl),
                options: [.retryFailed, .scaleDownLargeImages]
            ) { image in

                image
                    .resizable()
                    .scaledToFill()

            } placeholder: {

                Color.gray.opacity(0.15)
                    .overlay {
                        ProgressView()
                    }
            }
            .frame(height: 250)
            .frame(maxWidth: .infinity)
            .clipped()

            // overlays（純顯示，禁止吃點擊）
            .overlay(alignment: .bottomLeading) {
                BottomOverlay(post: post)
                    .allowsHitTesting(false)
            }
            .overlay(alignment: .topTrailing) {
                TopOverlay(post: post)
                    .allowsHitTesting(false)
            }

            // 點擊圖片進入 detail
            .contentShape(Rectangle())
            .onTapGesture {
                showPostInfo = true
            }

            // MARK: Action Area

            HStack(spacing: 16) {

                LikeButtonView(
                    viewModel: viewModel,
                    post: post
                )

                Button {
                    showComments = true
                } label: {
                    CommentCountView(
                        viewModel: viewModel,
                        post: post
                    )
                }

                Spacer()
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
        }

        // MARK: Navigation (iOS 16+ 正確方式)

        .navigationDestination(isPresented: $showPostInfo) {
            PostInfoView(post: post)
        }

        // MARK: Comments Sheet

        .sheet(isPresented: $showComments) {
            CommentListView(postId: post.id)
                .presentationDetents([.medium])
        }
    }
}

// MARK: Bottom Overlay

struct BottomOverlay: View {

    let post: Post

    var body: some View {

        LinearGradient(
            colors: [
                .black.opacity(0.7),
                .clear
            ],
            startPoint: .bottom,
            endPoint: .top
        )
        .frame(height: 140)
        .overlay(alignment: .bottomLeading) {

            VStack(alignment: .leading, spacing: 8) {

                HStack(alignment: .bottom) {

                    Text(post.title)
                        .font(.title2.bold())

                    Spacer()

                    Text(post.location)
                        .font(.headline)
                }

                HStack {

                    Text(post.author)
                        .font(.subheadline)

                    Spacer()

                    Image(post.type == "castle" ? "osaka-castle" : "ramen")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }
            }
            .padding()
            .foregroundStyle(.white)
        }
    }
}

// MARK: Top Overlay

struct TopOverlay: View {

    let post: Post

    var body: some View {

        VStack(alignment: .trailing, spacing: 8) {

            Text(formatDate(post.date ?? Date()))
                .font(.caption)
                .padding(8)
                .background(.black.opacity(0.4))
                .clipShape(Capsule())

            if let tags = post.tag {

                HStack {

                    ForEach(tags, id: \.self) { tag in

                        Text("#\(tag)")
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.myGreen2.opacity(0.8))
                            .clipShape(Capsule())
                    }
                }
            }
        }
        .padding()
        .foregroundStyle(.white)
    }
}

func formatDate(_ date: Date) -> String {

    let formatter = DateFormatter()

    formatter.dateStyle = .long
    formatter.timeStyle = .short

    return formatter.string(from: date)
}
