//
//  TagViewModel.swift
//  TOH
//
//  Created by Alia on 2025/4/10.
//

import Foundation
import SwiftUI
import FirebaseFirestore

struct Tag: Identifiable, Hashable {
    var id: String
    var name: String
    var count: Int
}

@MainActor
final class TagViewModel: ObservableObject {
    
    @Published var allTags: [Tag] = []
    @Published var selectedTags: [String] = []
    @Published var tagInput: String = ""
    
    private let db = Firestore.firestore()
    let maxTags = 3  // 最多三個標籤
    
    init() {
        fetchAllTags()
    }
    
    func fetchAllTags() {
        db.collection("tags").getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else { return }
            self.allTags = documents.map { doc in
                let data = doc.data()
                return Tag(
                    id: doc.documentID,
                    name: data["name"] as? String ?? "",
                    count: data["count"] as? Int ?? 0
                )
            }
        }
    }
    
    var canAddMoreTags: Bool { // 判斷還能不能新增標籤
        selectedTags.count < maxTags
    }

    var filteredTags: [Tag] { // 搜尋資料庫現有tag並排除已加入的
        if tagInput.isEmpty { return [] }
        return allTags.filter {
            $0.name.localizedCaseInsensitiveContains(tagInput) &&
            !selectedTags.contains($0.name)
        }
    }
    
    
    func addTag(_ tag: String) {  // 新增tag
        guard canAddMoreTags else { return }
        let trimmedTag = tag.trimmingCharacters(in: .whitespacesAndNewlines)
        if !selectedTags.contains(trimmedTag) {
            selectedTags.append(trimmedTag)
            tagInput = ""
        }
    }
    
    func removeTag(_ tag: String) {
        if let index = selectedTags.firstIndex(of: tag) {
            selectedTags.remove(at: index)
        }
    }
    
    // 創建貼文按下create才會更新資料庫的tag collection
    func updateTagCountsInFirestore() {
        for tagName in selectedTags {
            let tagRef = db.collection("tags").whereField("name", isEqualTo: tagName)
            tagRef.getDocuments { snapshot, error in
                if let doc = snapshot?.documents.first {
                    // tag 已存在 → count +1
                    let ref = doc.reference
                    ref.updateData(["count": FieldValue.increment(Int64(1))])
                } else {
                    // 新的 tag → 新增文件
                    self.db.collection("tags").addDocument(data: [
                        "name": tagName,
                        "count": 1
                    ])
                }
            }
        }
    }
    
}
