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
                    TagView(tagVM: tagVM)
                    imagePickerView
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
                            guard viewModel.selectedImage != nil else {
                                    viewModel.alertMsg = "No image selected"
                                    return
                            }
                            
                            Task{
                                let result = await viewModel.writePost(postTitle: postTitle, location: location, author: author, type: selectedCategory?.rawValue ?? "", comment: comment)
                                
                                print(result)
                                
                                tagVM.updateTagCountsInFirestore()
                                
                                
                            }
                            viewModel.createPost.toggle()
                            
                        }
                        .disabled(postTitle == "" || location == "")
                    }
                }
            }
        }
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
            typeSelectionView
            Divider()
        }
    }
    
    private var typeSelectionView: some View {
        HStack(spacing: 20) {
            ForEach([PostCategory.castle, PostCategory.ramen], id: \.self) { category in
                Button(action: {
                    selectedCategory = category
                }) {
                    categoryButtonView(for: category)
                }
            }
        }
    }

    private func categoryButtonView(for category: PostCategory) -> some View {
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
    

    private var imagePickerView: some View {
        VStack {
            PhotosPicker(
                selection: $viewModel.selectedImagePickerItem,
                matching: .images,
                photoLibrary: .shared()) {
                    HStack {
                        Image(systemName: "photo.badge.plus.fill")
                        Text("Select post photo")
                    }
                }

            if let image = viewModel.selectedImage {
                GeometryReader { geometry in
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.width) // 1:1 長寬比
                        .clipped() // 裁剪多餘的部分
                        //.cornerRadius(10)
                        .padding()
                }
                .frame(height: 200) // 固定高度（這會根據圖片的長寬比來調整寬度）
                .transition(.opacity)
                
            } else {
                Text("尚未選擇圖片")
            }
        }
    }

    
}


#Preview {
    CreatePostView()
}
