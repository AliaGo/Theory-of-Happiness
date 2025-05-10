//
//  PostInfoView.swift
//  TOH
//
//  Created by Alia on 2025/4/8.
//

import SwiftUI
import UIKit
import FirebaseAnalytics

struct PostInfoView: View {
    
    @StateObject private var viewModel = StoryViewModel()
    
    //避免重複觸發.onAppear 的追蹤碼
    @State private var hasTracked = false
    
    let post: Post
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 10){
                HStack{
                    Image(systemName: "person.circle.fill")
                    Text(post.author)
                }
                
                HStack {
                    Image(systemName: "mappin.and.ellipse")
                    Text(post.location)
                }
                
                HStack {
                    Image(systemName: "calendar.circle")
                    Text(viewModel.formatDate(post.visitedDate ?? Date()))
                }
                
                HStack {
                    Image(systemName: "pencil.line")
                    Text(post.comment ?? "")
                }
                
                HStack{
                    Image(systemName: "tag")
                    if let tags = post.tag {
                        ForEach(tags, id: \.self) { tag in
                            Text("#\(tag)")
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.myGreen2.opacity(0.6))
                                .cornerRadius(12)
                                .foregroundColor(Color.white)
                        }
                        
                    }
                }
                
                GeometryReader { geometry in
                    AsyncImage(url: URL(string: post.postPhotoPathUrl)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width, height: geometry.size.width) // 使用寬度來設置長寬比1:1
                            .clipped()
                            .padding(.vertical, 10)  // 為圖片增加上下空間
                    } placeholder: {
                        ProgressView()
                            .frame(width: geometry.size.width, height: geometry.size.width)
                            .padding(.vertical, 10)
                    }
                }
                .frame(height: 300)
                
            }
        }
        .navigationTitle(post.title)
        .onAppear {
          if !hasTracked {
            Analytics.logEvent("view_story_detail", parameters: [
                "post_id": post.id,
                "author_id": post.userId
            ])
            hasTracked = true
          }
        }
        
    }
}

