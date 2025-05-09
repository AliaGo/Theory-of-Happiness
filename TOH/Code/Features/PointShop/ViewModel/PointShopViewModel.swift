//
//  PointShopViewModel.swift
//  TOH
//
//  Created by Alia on 2025/5/4.
//

import SwiftUI
import FirebaseFirestore

struct ShopItem: Identifiable, Codable {
    let id: String?
    let name: String
    let description: String
    let cost: Int
    let type: String
    let imageURL: String?
    let isLimited: Bool?
}

enum ShopItemType: String, CaseIterable, Identifiable {
    case title = "title"
    case badge = "badge"
    case theme = "theme"

    var id: String { self.rawValue }
}

@MainActor
class PointShopViewModel: ObservableObject {
    @Published var items: [ShopItem] = []
    @Published var selectedType: ShopItemType = .title
    @Published var userPoints: Int = 0  // 從 UserManager 抓

    var filteredItems: [ShopItem] {
        return items.filter { $0.type == selectedType.rawValue.lowercased() }
    }
    
    func fetchShopItems() async {
        let snapshot = try? await Firestore.firestore()
            .collection("products")
            .getDocuments()
        
        if let docs = snapshot?.documents {
            self.items = docs.compactMap { try? $0.data(as: ShopItem.self) }
        }
        
        
    }

    func redeem(item: ShopItem) {
        // 這裡可以扣點 + 儲存到使用者已擁有的紀錄
    }
}
