import SwiftUI
import FirebaseCore

struct CommentListView: View {
    @StateObject private var viewModel = PostViewModel()
    let postId: String
    @State private var comments: [Comment] = []
    @State private var newComment = ""

    var body: some View {
        VStack(alignment: .leading) {
            // 留言列表
            ScrollView {
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(viewModel.comments, id: \.id) { comment in
                        CommentRow(
                            username: comment.userNickname ?? "匿名",
                            text: comment.text,
                            timestamp: comment.timestamp
                        )
                    }
                }
                .padding()
            }

            Divider()

            // 留言輸入區
            HStack {
                TextField("留言……", text: $newComment)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button {
                    guard !newComment.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                    viewModel.addComment(postId: postId, text: newComment)
                    newComment = ""
                } label: {
                    Image(systemName: "paperplane.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
            }
            .padding()
        }
        .onAppear {
            viewModel.observeComments(postId: postId)
        }
    }
}

struct CommentRow: View {
    let username: String
    let text: String
    let timestamp: Timestamp

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            // 頭像圈圈
            Circle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 36, height: 36)
                .overlay(
                    Text(String(username.prefix(1))) // 顯示名字首字
                        .font(.subheadline)
                        .foregroundColor(.black)
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(username)
                    .font(.subheadline)
                    .bold()
                Text(text)
                    .font(.body)
            }

            Spacer()
            
            Text(formatDate(timestamp.dateValue()))
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}

