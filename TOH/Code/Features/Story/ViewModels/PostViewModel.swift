// 按讚、留言、儲存、分享，都用這個Model
//  PostViewModel.swift
//  TOH
//
//  Created by Alia on 2025/10/10.
//
import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

@MainActor
final class PostViewModel: ObservableObject {
    @Published var posts: [Post]?
    @Published var comments: [Comment] = []
    @Published var currentUserNickname: String = "匿名"
    var currentUserId: String {
        Auth.auth().currentUser?.uid ?? ""
    }
    
    init() {
        fetchCurrentUserNickname()
    }

    private func fetchCurrentUserNickname() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("users").document(uid).getDocument { snapshot, error in
            if let data = snapshot?.data(),
               let nickname = data["userNickname"] as? String {
                DispatchQueue.main.async {
                    self.currentUserNickname = nickname
                }
            } else {
                DispatchQueue.main.async {
                    self.currentUserNickname = "匿名"
                }
            }
        }
    }
    
    func toggleLike(for post: Post) {
        let postId = post.id

        PostManager.shared.toggleLike(postId: postId, userId: currentUserId)
    }
    
    func addComment(postId: String, text: String) {
        PostManager.shared.addComment(postId: postId, userId: currentUserId, userNickname: currentUserNickname, text: text)
    }

    func reportComment(postId: String, comment: Comment) async throws {
        try await PostManager.shared.reportComment(
            postId: postId,
            comment: comment,
            reporterId: currentUserId
        )
    }
    
    //為什麼要 [weak self]?
    //避免循環引用（memory leak），因為 addSnapshotListener 是長期監聽。
    func fetchComments(postId: String){
        PostManager.shared.fetchComments(postId: postId) { [weak self] comments in
                    // 更新 ViewModel 的 comments
            self?.comments = comments
        }
    }
    
    func observeComments(postId: String) {
        PostManager.shared.fetchComments(postId: postId) { comments in
            DispatchQueue.main.async {
                self.comments = comments
            }
        }
    }
    
    func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long // 设置日期样式，可以选择.short, .medium, .long, .full
        dateFormatter.timeStyle = .none // 不显示时间，如果需要显示时间可以设置为 .short 或 .medium

        return dateFormatter.string(from: date) // 返回格式化后的日期字符串
    }
}
