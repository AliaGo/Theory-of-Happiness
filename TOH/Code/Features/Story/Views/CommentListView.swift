import SwiftUI
import FirebaseCore

struct CommentListView: View {
    @StateObject private var viewModel = PostViewModel()
    let postId: String
    @State private var comments: [Comment] = []
    @State private var newComment = ""
    @State private var commentToReport: Comment?
    @State private var showReportConfirmation = false
    @State private var showReportSuccess = false
    @State private var reportErrorMessage = ""
    @State private var showReportError = false

    var body: some View {
        VStack(alignment: .leading) {
            // 留言列表
            ScrollView {
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(viewModel.comments, id: \.id) { comment in
                        CommentRow(
                            username: comment.userNickname ?? "匿名",
                            text: comment.text,
                            timestamp: comment.timestamp,
                            reportAction: {
                                commentToReport = comment
                                showReportConfirmation = true
                            }
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
        .confirmationDialog("檢舉這則留言？", isPresented: $showReportConfirmation, titleVisibility: .visible) {
            Button("送出檢舉", role: .destructive) {
                guard let commentToReport else { return }
                Task {
                    do {
                        try await viewModel.reportComment(postId: postId, comment: commentToReport)
                        showReportSuccess = true
                    } catch {
                        reportErrorMessage = error.localizedDescription
                        showReportError = true
                    }
                }
            }
            Button("取消", role: .cancel) {}
        } message: {
            Text("這會將留言內容與必要資訊送交管理員檢視。")
        }
        .alert("已收到檢舉", isPresented: $showReportSuccess) {
            Button("確定", role: .cancel) {}
        } message: {
            Text("謝謝你的回報，我們會儘快檢視這則留言。")
        }
        .alert("無法送出檢舉", isPresented: $showReportError) {
            Button("確定", role: .cancel) {}
        } message: {
            Text(reportErrorMessage)
        }
    }
}

struct CommentRow: View {
    let username: String
    let text: String
    let timestamp: Timestamp
    let reportAction: () -> Void

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

            VStack(alignment: .trailing, spacing: 6) {
                Menu {
                    Button("檢舉此內容", role: .destructive, action: reportAction)
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.tertiary)
                        .frame(width: 22, height: 18)
                }
                .buttonStyle(.borderless)
                .accessibilityLabel("留言選單")

                Text(formatDate(timestamp.dateValue()))
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
    }
}
