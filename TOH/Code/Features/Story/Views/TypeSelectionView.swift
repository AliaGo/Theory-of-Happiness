//
//  TypeSelectionView.swift
//  TOH
//
//  Created by Alia on 2025/5/3.
//

import SwiftUI

struct TypeSelectionView: View {
    @Binding var selectedCategory: PostCategory?

    var body: some View {
        HStack(spacing: 20) {
            ForEach([PostCategory.castle, PostCategory.ramen], id: \.self) { category in
                Button(action: {
                    selectedCategory = category
                }) {
                    VStack {
                        Image(category == .castle ? "osaka-castle" : "ramen")
                            .resizable()
                            .frame(maxWidth:30, maxHeight:25)
                            .scaledToFit()
                        Text(category == .castle ? "城堡" : "拉麵")
                            .font(.caption)
                            .foregroundStyle(Color.white)
                    }
                    .padding()
                    .background(selectedCategory == category ? Color.blue : Color.blue.opacity(0.2))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(selectedCategory == category ? Color.blue : Color.gray, lineWidth: 1)
                    )
                }
            }
        }
    }
}

