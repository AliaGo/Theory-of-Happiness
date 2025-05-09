//
//  CreatePostView.swift
//  TOH
//
//  Created by Alia on 2025/3/18.
//

import SwiftUI
import PhotosUI
import UIKit

enum PostCategory: String, Codable {
    case castle = "castle"
    case ramen = "ramen"
}

struct CreatePostView: View {
    @EnvironmentObject var viewModel: StoryViewModel
    @Environment(\.dismiss) private var dismiss
    @StateObject var tagVM = TagViewModel()
    
    // Post properties
    @State var postTitle = ""
    @State var location = ""
    @State var author = ""
    @State var type = ""
    @State var date = Date()
    @State var comment = ""
    @State private var selectedTags: [String] = []
    @State private var selectedCategory: PostCategory? = nil
    @FocusState var showKeyboard: Bool
    @FocusState private var isTagFieldFocused: Bool

    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 15) {
                    postTitleView
                    //authorView
                    locationAndTypeView
                    dateAndCommentView
                    TagView(tagVM: tagVM, selectedTags: $selectedTags)
                    ImagePickerView(viewModel: viewModel)
                }
            }
            .task {
                try? await viewModel.loadCurrentUser()
            }
            .onChange(of: viewModel.selectedImagePickerItem) { newValue in
                if let newValue {
                    viewModel.selectImage(item: newValue)
                }
            }
            .navigationTitle("New Post")
            .navigationBarTitleDisplayMode(.inline)
            .alert(viewModel.alertMsg, isPresented: $viewModel.showAlert) {}
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    
                    if !showKeyboard{
                        Button("Cancel") {
                            viewModel.createPost.toggle()
                            //dismiss() // 手動關閉 fullScreenCover
                            viewModel.selectedImage = nil
                        }
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing){
                    
                    if showKeyboard {
                        Button("Done"){
                            // Closing keyboard
                            showKeyboard.toggle()
                        }
                    }
                    else{
                        Button("Create"){
                            handleCreatePost()
                        }
                        .disabled(postTitle == "" || location == "" || viewModel.selectedImage == nil)
                    }
                }
            }
        }
    }

    func handleCreatePost() {
        guard viewModel.selectedImage != nil else {
            viewModel.alertMsg = "No image selected"
            viewModel.showAlert = true
            return
        }

        Task {
            //tagVM.selectedTags = selectedTags
            
            let result = await viewModel.writePost(
                postTitle: postTitle,
                location: location,
                author: author,
                type: selectedCategory?.rawValue ?? "",
                comment: comment,
                tags: selectedTags
            )

            if result == 1 {
                viewModel.updateStamps(stamps: 1, castleName: viewModel.earnedStamp ?? "")
            } else if result == 2 {
                viewModel.updatePoints(points: 1)
            }
            
            tagVM.updateTagCountsInFirestore()
            // 清空
            selectedTags = []
            tagVM.selectedTags = []
            
        }
        // 關閉 Create Post 視圖
        viewModel.createPost.toggle()
    }

    
    // MARK: - Views
    private var postTitleView: some View {
        VStack(alignment: .leading) {
            TextField("Post Title", text: $postTitle)
                .font(.title2)
            Divider()
        }
    }
    
    private var authorView: some View {
        VStack(alignment: .leading, spacing: 11) {
            Text("Author:").font(.caption.bold())
            TextField("Author", text: $author)
            Divider()
        }
        .padding(.top, 5)
        .padding(.bottom, 20)
    }

    private var locationAndTypeView: some View {
        VStack(alignment: .leading, spacing: 11) {
            Text("Location:").font(.caption.bold())
            TextField("location", text: $location)
            Divider()
            Text("Type:").font(.caption.bold())
            TypeSelectionView(selectedCategory: $selectedCategory)
            Divider()
        }
    }

    private var dateAndCommentView: some View {
        VStack(alignment: .leading) {
            Text("Date:").font(.caption.bold())
            Text(viewModel.formatDate(viewModel.photoDate ?? Date()))
            
            Divider()
            
            Text("Comment:").font(.caption.bold())
            TextField("comment", text: $comment)
            
            Divider()
        }
    }
    

    
    
}


#Preview {
    CreatePostView()
}
