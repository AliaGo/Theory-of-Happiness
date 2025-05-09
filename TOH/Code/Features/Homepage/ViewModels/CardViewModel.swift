//
//  Card.swift
//  TOH
//
//  Created by Alia on 2025/2/19.
//

import Foundation
import SwiftUI
import FirebaseFirestore

@MainActor
final class CardViewModel: ObservableObject {
    
    @Published var cards = [Card]()
    
    private var db = Firestore.firestore()
    
    var filteredCastleQA: [Card] {
        return cards.filter { $0.type == "castleQA" }
    }
    
    var filteredCastleKnowledge: [Card] {
        return cards.filter { $0.type == "castleKnowledge" }
    }
    
    var filteredRamenKnowledge: [Card] {
        return cards.filter { $0.type == "ramenKnowledge" }
    }
    
    func fetchAllCard() async throws{
        self.cards = try await db.collection("cards").getDocuments(as: Card.self)
    }
    
    func loadCards(for type: String) async throws{
        do {
            print("start")
            let snapshot = try await db.collection("cards").getDocuments()

            let fetchedCards = snapshot.documents.compactMap { document in
                do {
                    return try document.data(as: Card.self)
                } catch {
                    print("❌ 解碼失敗：\(document.documentID) -> \(error)")
                    return nil
                }
            }

            print(fetchedCards[3])
            // 根據 type 進行過濾
            self.cards = fetchedCards.filter { $0.type == type }
            print(cards.count)
        } catch {
            print("❌ 載入 \(type) 卡片失敗：\(error)")
        }
    }
    
}


