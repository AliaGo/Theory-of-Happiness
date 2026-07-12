//
//  ImageGalleryView.swift
//  TOH
//
//  Created by Alia on 2025/8/15.
//

import SwiftUI
import SDWebImageSwiftUI

struct ImageGalleryView: View {
    let urls: [String]
    
    // 控制全螢幕顯示
    @State private var showFullScreen = false
    @State private var selectedIndex = 0
    
    // 三欄 grid
    let columns = [GridItem(.flexible(), spacing: 8),
                   GridItem(.flexible(), spacing: 8),
                   GridItem(.flexible(), spacing: 8)]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(Array(urls.enumerated()), id: \.offset) { idx, urlString in
                AsyncImage(url: URL(string: urlString)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Color.gray.opacity(0.3)
                }
                .frame(width: (UIScreen.main.bounds.width-48)/3,
                       height: (UIScreen.main.bounds.width-48)/3)
                .clipped()
                .cornerRadius(8)
                .onTapGesture {
                    selectedIndex = idx
                    showFullScreen = true
                }
            }
        }
        //.padding(.vertical, 8)
        .ignoresSafeArea()
        // Fullscreen 瀏覽器
        .fullScreenCover(isPresented: $showFullScreen) {
            FullscreenImageViewer(urls: urls, selectedIndex: selectedIndex)
        }
    }
}

// MARK: - Fullscreen Viewer
struct FullscreenImageViewer: View {
    let urls: [String]
    @State var selectedIndex: Int
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            TabView(selection: $selectedIndex) {
                ForEach(Array(urls.enumerated()), id: \.offset) { idx, urlString in
                    AsyncImage(url: URL(string: urlString)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .tag(idx)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.black)
                    } placeholder: {
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.black)
                            .tag(idx)
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            
            // 關閉按鈕
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 30))
                    .foregroundColor(.white)
                    .padding()
            }
            
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}
