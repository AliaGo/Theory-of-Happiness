//
//  LikeButtonView.swift
//  TOH
//
//  Created by Alia on 2025/10/10.
//

import SwiftUI

struct LikeButtonView: View {
    @ObservedObject var viewModel: PostViewModel
    let post: Post

    var body: some View {
        Button {
            print("❤️ LIKE")
            viewModel.toggleLike(for: post)
        } label: {
            HStack(spacing: 4) {
                Image(systemName: (post.likes?.contains(viewModel.currentUserId))! ? "heart.fill" : "heart")
                    .foregroundColor((post.likes?.contains(viewModel.currentUserId))! ? .red : .gray)
                Text("\(post.likeCount)")
                    .foregroundColor(.gray)
                    .font(.subheadline)
            }
        }
    }
}

