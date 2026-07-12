import SwiftUI

// MARK: - Mock Data
struct MockPost: Identifiable {
    var id = UUID().uuidString
    var title: String
    var postPhotoUrl: String
    var author: String
    var likeCount: Int
    var commentCount: Int
}

// MARK: - Main PostBlockView
struct MockPostBlockView: View {
    var post: MockPost
    @State private var isLiked = false
    @State private var showComments = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // 貼文圖片
            ZStack(alignment: .bottomLeading) {
                AsyncImage(url: URL(string: post.postPhotoUrl)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(height: 300)
                            .frame(maxWidth: .infinity)
                            .background(Color.gray.opacity(0.2))
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: 300)
                            .clipped()
                    case .failure:
                        Color.gray.opacity(0.2)
                            .frame(height: 300)
                    @unknown default:
                        EmptyView()
                    }
                }
                
                // 圖片底部的文字疊層
                LinearGradient(colors: [.black.opacity(0.6), .clear],
                               startPoint: .bottom, endPoint: .top)
                    .frame(height: 100)
                    .overlay(alignment: .bottomLeading) {
                        VStack(alignment: .leading) {
                            Text(post.title)
                                .font(.headline)
                                .foregroundColor(.white)
                            Text("by \(post.author)")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .padding()
                    }
            }
            
            // 按讚 + 留言按鈕
            HStack(spacing: 16) {
                Button(action: {
                    isLiked.toggle()
                }) {
                    Label("\(post.likeCount + (isLiked ? 1 : 0))", systemImage: isLiked ? "heart.fill" : "heart")
                        .foregroundColor(isLiked ? .red : .gray)
                        .font(.title3)
                }
                
                Button(action: {
                    showComments.toggle()
                }) {
                    Label("\(post.commentCount)", systemImage: "text.bubble")
                        .foregroundColor(.gray)
                        .font(.title3)
                }
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 4)
        .padding()
        .sheet(isPresented: $showComments) {
            CommentListFullScreenView(isPresented: $showComments)
        }
    }
}

// MARK: - FullScreen Comment View
struct CommentListFullScreenView: View {
    @Binding var isPresented: Bool
    @State private var newComment = ""
    
    let comments = [
        CommentRow(username: "Alice", text: "超漂亮的城堡！"),
        CommentRow(username: "Bob", text: "請問這是哪裡拍的？")
    ]
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(comments.indices, id: \.self) { index in
                            comments[index]
                        }
                    }
                    .padding()
                }
                
                Divider()
                
                // 新增留言輸入區
                HStack {
                    TextField("留下留言...", text: $newComment)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button {
                        // 實際留言送出行為在正式版可加入 Firebase 處理
                        newComment = ""
                    } label: {
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(.blue)
                            .font(.title2)
                    }
                }
                .padding()
            }
            .navigationTitle("留言")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("關閉") {
                        isPresented = false
                    }
                }
            }
        }
    }
}



// MARK: - 預覽
#Preview {
    MockPostBlockView(post: MockPost(
        title: "大阪城天守閣",
        postPhotoUrl: "https://upload.wikimedia.org/wikipedia/commons/5/5d/Osaka_Castle_02bs3200.jpg",
        author: "リア",
        likeCount: 42,
        commentCount: 12
    ))
}
