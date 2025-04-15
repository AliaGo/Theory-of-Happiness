//
//  PostInfoView.swift
//  TOH
//
//  Created by Alia on 2025/4/8.
//

import SwiftUI
import UIKit

struct PostInfoView: View {
    
    @StateObject private var viewModel = StoryViewModel()
    
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
    }
}

