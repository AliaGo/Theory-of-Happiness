//
//  ImagePickerSection.swift
//  TOH
//
//  Created by Alia on 2025/5/3.
//

import SwiftUI
import _PhotosUI_SwiftUI

struct ImagePickerView: View {
    @ObservedObject var viewModel: StoryViewModel

    var body: some View {
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
                        .frame(width: geometry.size.width, height: geometry.size.width)
                        .clipped()
                        .padding()
                }
                .frame(height: 200)
                .transition(.opacity)
            } else {
                Text("尚未選擇圖片")
            }
        }
    }
}
