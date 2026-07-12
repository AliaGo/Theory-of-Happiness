//
//  CommentCountView.swift
//  TOH
//
//  Created by Alia on 2026/5/22.
//

import SwiftUI

struct CommentCountView: View {
    @ObservedObject var viewModel: PostViewModel
    let post: Post

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "bubble")
                .foregroundColor(.gray)
            Text("\(post.commentCount)")
                .foregroundColor(.gray)
                .font(.subheadline)
        }
    }
}

