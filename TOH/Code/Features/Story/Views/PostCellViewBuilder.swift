//
//  PostCellViewBuilder.swift
//  TOH
//
//  Created by Alia on 2025/4/8.
//

import SwiftUI

struct PostCellViewBuilder: View {
    
    let postId: String
    @State private var post: Post? = nil
    
    var body: some View {
        ZStack{
            if let post {
                PostBlockView(post: post)
            }
        }
        .task {
            self.post = try? await PostManager.shared.getPost(postId: postId)
        }
    }
}

struct PostBlockView: View {
    var post: Post
    
    var body: some View {
        NavigationLink {
            PostInfoView(post: post)
        } label: {
            GeometryReader { geometry in
                AsyncImage(url: URL(string: post.postPhotoPathUrl)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.width) // 使用寬度來設置長寬比1:1
                        .clipped() // 裁剪超出範圍的部分
                } placeholder: {
                    ProgressView()
                        .frame(width: geometry.size.width, height: geometry.size.width)
                }
            }
            .overlay {
                PostTextOverlay(post: post)
            }
            //.clipped()
            .frame(height: 300)
            
        }
    }
}

struct PostTextOverlay: View {
    
    var post: Post

    var gradient: LinearGradient {
        .linearGradient(
            Gradient(colors: [.black.opacity(0.6), .black.opacity(0)]),
            startPoint: .bottom,
            endPoint: .center)
    }


    var body: some View {
        ZStack(alignment: .topTrailing) {
            ZStack(alignment: .bottomLeading) {
                gradient
                VStack(alignment: .leading) {
                    HStack(alignment: .bottom) {
                        Text(post.title)
                            .font(.title)
                            .bold()
                        
                        Spacer()
                        
                        Text(post.location)
                            .font(.title3)
                            .bold()
                    }
                       

                    HStack{
                        Text(post.author)
                        
                        Spacer()
                        
                        Image(post.type == "castle" ? "osaka-castle" : "ramen")
                            .resizable()
                            .frame(maxWidth:20, maxHeight:20)
                            .scaledToFit()
                    }
                    
                }
                .padding()
            }
            
            VStack(alignment: .trailing) {
                // 右上角的日期
                Text(formatDate(post.date ?? Date()))
                    .font(.caption)
                    .padding(8)
                
                HStack{
                    if let tags = post.tag {
                        ForEach(tags, id: \.self) { tag in
                            Text("#\(tag)")
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .font(.footnote)
                                .background(Color.myGreen2.opacity(0.6))
                                .cornerRadius(12)
                        }
                        
                    }
                }
                
            }
            
        }
        .foregroundStyle(.white)
    }
}

func formatDate(_ date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .long // 设置日期样式，可以选择.short, .medium, .long, .full
    dateFormatter.timeStyle = .short // 不显示时间，如果需要显示时间可以设置为 .short 或 .medium

    return dateFormatter.string(from: date) // 返回格式化后的日期字符串
}
