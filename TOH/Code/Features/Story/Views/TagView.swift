//
//  TagView.swift
//  TOH
//
//  Created by Alia on 2025/4/10.
//

import SwiftUI

struct TagView: View {
    @ObservedObject var tagVM: TagViewModel
    @Binding var selectedTags: [String]
    @FocusState private var isTagFieldFocused: Bool
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 11) {
            Text("Tag:").font(.caption.bold())
            
            TextField("add tags up to 3", text: $tagVM.tagInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .focused($isTagFieldFocused)
            
            // 📌 自動建議（只有在 Focus 時才出現）
            if isTagFieldFocused && !tagVM.tagInput.isEmpty {
                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
                        // 顯示匹配到的既有 tag
                        ForEach(tagVM.filteredTags, id: \.id) { tag in
                            Button {
                                tagVM.addTag(tag.name)
                                isTagFieldFocused = false // 收起鍵盤與選單
                            } label: {
                                Text("#\(tag.name)")
                                    .foregroundColor(.blue)
                            }
                        }

                        // ➕ 新增自訂 tag
                        if !tagVM.allTags.contains(where: { $0.name == tagVM.tagInput }) {
                            Button {
                                tagVM.addTag(tagVM.tagInput)
                                isTagFieldFocused = false
                            } label: {
                                Text("新增「#\(tagVM.tagInput)」")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
            }
            
            // ✅ 顯示已選標籤
            HStack {
                ForEach(selectedTags, id: \.self) { tag in
                    HStack(spacing: 4) {
                        Text("#\(tag)")
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(12)

                        Button {
                            tagVM.removeTag(tag)
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
        }
        .onChange(of: tagVM.selectedTags) { newValue in
            selectedTags = newValue
        }
        .onChange(of: selectedTags) { newValue in
            tagVM.selectedTags = newValue
        }
    }
}

