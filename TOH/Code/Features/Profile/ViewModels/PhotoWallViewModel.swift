//
//  PhotoWallViewModel.swift
//  TOH
//
//  Created by Alia on 2025/10/15.
//

import SwiftUI

@MainActor
final class PhotoWallViewModel: ObservableObject {
    @Published var photos: [Photo] = []
    @Published var isLoading = true
    @Published var selectedPost: Post? = nil

    // 載入照片
    func loadPhotos(userId: String, type: PhotoManager.PhotoType) async {
        isLoading = true
        do {
            self.photos = try await PhotoManager.shared.fetchPhotos(userId: userId, type: type)
        } catch {
            print("❌ Failed to fetch \(type.rawValue) photos:", error)
        }
        self.isLoading = false
    }

    // 點擊照片時載入完整 Post
    func loadPostAndShow(postId: String) async {
        do {
            let post = try await PostManager.shared.getPost(postId: postId)
            await MainActor.run {
                self.selectedPost = post
            }
        } catch {
            print("❌ Failed to fetch post:", error)
        }
    }
}
