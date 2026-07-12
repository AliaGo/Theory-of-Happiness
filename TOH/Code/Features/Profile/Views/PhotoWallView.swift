// 城堡牆
import SwiftUI

struct PhotoWallCastleView: View {
    let userId: String
    @StateObject private var viewModel = PhotoWallViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                if viewModel.isLoading {
                    ProgressView().padding(.top, 100)
                } else if viewModel.photos.isEmpty {
                    Text("尚無城堡照片")
                        .foregroundColor(.gray)
                        .padding(.top, 100)
                } else {
                    LazyVStack(alignment: .leading, spacing: 20) {
                        ForEach(viewModel.photos) { photo in
                            PhotoDiaryCell(photo: photo) {
                                Task {
                                    await viewModel.loadPostAndShow(postId: photo.postId)
                                }
                            }
                        }
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("🏯 城堡旅程紀錄")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss() // 點 X 回上一頁
                    } label: {
                        Image(systemName: "xmark")
                            .imageScale(.medium)
                    }
                }
            }
            // iOS16+ 版本適用
            .navigationDestination(isPresented: Binding<Bool>(
                get: { viewModel.selectedPost != nil },
                set: { newValue in
                    if !newValue { viewModel.selectedPost = nil }
                }
            )) {
                if let post = viewModel.selectedPost {
                    PostInfoView(post: post)
                }
            }
        }
        .task {
            await viewModel.loadPhotos(userId: userId, type: .castle)
        }
    }
}


// 拉麵牆

struct PhotoWallRamenView: View {
    let userId: String
    @StateObject private var viewModel = PhotoWallViewModel()
    @Environment(\.dismiss) private var dismiss
    
    private let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        NavigationStack {
            ScrollView {
                if viewModel.isLoading {
                    ProgressView().padding(.top, 100)
                } else if viewModel.photos.isEmpty {
                    Text("尚無拉麵照片")
                        .foregroundColor(.gray)
                        .padding(.top, 100)
                } else {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(viewModel.photos) { photo in
                            PhotoGridCell(photo: photo) {
                                Task {
                                    await viewModel.loadPostAndShow(postId: photo.postId)
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("🍜 拉麵紀錄牆")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss() // 點 X 回上一頁
                    } label: {
                        Image(systemName: "xmark")
                            .imageScale(.medium)
                    }
                }
            }
            // 🔹 iOS16+ 適用navigationDestination
            .navigationDestination(isPresented: Binding<Bool>(
                get: { viewModel.selectedPost != nil },
                set: { newValue in
                    if !newValue { viewModel.selectedPost = nil }
                }
            )) {
                if let post = viewModel.selectedPost {
                    PostInfoView(post: post)
                }
            }
            .task {
                await viewModel.loadPhotos(userId: userId, type: .ramen)
            }
        }
    }
}
