//
//  StoryView.swift
//  TOH
//
//  Created by Alia on 2025/3/14.
//

import SwiftUI

struct StoryView: View {
    @StateObject private var viewModel = StoryViewModel()
    
    var body: some View {
        NavigationStack{
            if let posts = viewModel.posts {
                
                if posts.isEmpty {
                    Text("No Story existed")
                } else {
                    /*
                    NavigationStack {
                        ScrollView(.vertical) {
                            ForEach(posts.sorted(by: { $0.date > $1.date }), id: \.id) {
                                post in
                                    PostCellViewBuilder(postId: post.id)
                            }
                            .listRowSpacing(10)
                            .listRowInsets(EdgeInsets())
                            .listStyle(.insetGrouped)
                        }
                    }
                    .navigationTitle("Stories")
                    */
                    NavigationStack{
                        List(posts, id: \.id){ post in
                            PostCellViewBuilder(postId: post.id)
                        }
                        .listRowSpacing(10)
                        //.listRowInsets(EdgeInsets())
                        .listStyle(.insetGrouped)
                    }
                    .navigationTitle("Stories")
                    
                }
                
                
            } else {
                ProgressView()
            }
            
            
        }
        .navigationTitle("Stories")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(
            ZStack {
                // 印章提示 Dialog
                if viewModel.showResultDialog {
                    ZStack {
                        Color.black.opacity(0.4)
                            .ignoresSafeArea()
                        
                        VStack(spacing: 16) {
                            if let stamp = viewModel.earnedStamp {
                                Text("獲得印章！🎉")
                                    .font(.title2)
                                    .bold()
                                Image(stamp)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                Text(stamp)
                                    .font(.headline)
                            } else if let message = viewModel.earnedPointMessage {
                                Text("謝謝你在拉麵的貢獻")
                                    .font(.title2)
                                    .bold()
                                Text(message)
                                    .multilineTextAlignment(.center)
                                    .padding(.top, 5)
                            }
                            
                            Button("確認") {
                                viewModel.resetResultState()
                            }
                            .padding(.top, 10)
                        }
                        .padding()
                        .background(.regularMaterial)
                        .cornerRadius(16)
                        .frame(maxWidth: 300)
                        .shadow(radius: 10)
                    }
                }
                
                // 右下角「＋」按鈕
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            viewModel.createPost.toggle()
                        }, label: {
                            Image(systemName: "plus")
                                .font(.title2.bold())
                                .foregroundColor(Color.white)
                                .padding()
                                .background(.myGreen2, in: Circle())
                        })
                        .padding()
                    }
                }
            }
        )

        .onAppear{
            viewModel.fetchPosts()
        }
        .fullScreenCover(isPresented: $viewModel.createPost, content: {
            //post view
            CreatePostView()
                .overlay(
                
                    ZStack {
                        Color.primary.opacity(0.25)
                            .ignoresSafeArea()
                        
                        ProgressView()
                            .frame(width: 80, height: 80)
                        
                    }
                        .opacity(viewModel.isWriting ? 1 : 0)
                )
                .environmentObject(viewModel)
        })
        .alert(viewModel.alertMsg, isPresented: $viewModel.showAlert) {
            
        }
    }
    
    @ViewBuilder
    func StoryCardView(post: Post)->some View {
        
        NavigationLink {
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack{
                    Text(post.title)
                    
                    Text(post.author)
                    
                    Text(post.location)
                    
                    Text(post.type)
                    
                    
                    AsyncImage(url: URL(string: post.postPhotoPathUrl)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: 80, maxHeight: 80,alignment: .center)
                    } placeholder: {
                        ProgressView()
                            .frame(maxWidth: 80, maxHeight: 80)
                    }
                    
                }
            }
            .navigationTitle(post.title)
            
        } label: {
            VStack(alignment: .leading, spacing: 12) {
                
                Text(post.author)
                
                Text(post.title)
                
                Text(post.location)
                
                Text(post.type)
                
                //Text(post.date.dateValue().formatted(date: .numeric, time: .shortened))
                    //.font(.caption.bold())
                    //.foregroundStyle(.gray)
            }
        }
        
        
    }
}



#Preview {
    StoryView()
}

