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
                    NavigationStack{
                        List(posts){ post in
                            PostCellViewBuilder(postId: post.id)
                        }
                        .listRowSpacing(10)
                        .listRowInsets(EdgeInsets())
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
            
            ,alignment: .bottomTrailing
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
