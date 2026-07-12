//
//  PhotoWallCell.swift
//  TOH
//
//  Created by Alia on 2025/10/15.
//
// 日記式跟九宮格式
import SwiftUI

struct PhotoDiaryCell: View {
    let photo: Photo
    let onTap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AsyncImage(url: URL(string: photo.imagePath)) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width - 40, height: 300)
                    .clipped()
                    .cornerRadius(16)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: UIScreen.main.bounds.width - 40, height: 300)
                    .cornerRadius(16)
            }
            .onTapGesture(perform: onTap)

            Text(photo.location ?? "未知地點").font(.headline)
            Text(photo.formattedDate).font(.caption).foregroundColor(.gray)
            if let desc = photo.description, !desc.isEmpty {
                Text(desc).font(.body)
            }
        }
        .padding(.horizontal, 20)
    }
}


import SwiftUI

struct PhotoGridCell: View {
    let photo: Photo
    let onTap: () -> Void

    var body: some View {
        AsyncImage(url: URL(string: photo.imagePath)) { image in
            image
                .resizable()
                .scaledToFill()
                .frame(width: (UIScreen.main.bounds.width - 40) / 3, height: (UIScreen.main.bounds.width - 40) / 3)
                .clipped()
                .cornerRadius(8)
        } placeholder: {
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(width: (UIScreen.main.bounds.width - 40) / 3, height: (UIScreen.main.bounds.width - 40) / 3)
                .cornerRadius(8)
        }
        .onTapGesture(perform: onTap)
    }
}
