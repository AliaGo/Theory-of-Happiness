//
//  CastleViewModel.swift
//  TOH
//
//  Created by Alia on 2025/2/6.
//

import Foundation
import SwiftUI
// New
import FirebaseFirestore

@MainActor
final class CastleViewModel: ObservableObject {
    
    @Published private(set) var castles: [Castle] = []
    @Published private(set) var isFavorite: Bool = false
    
    // New
    private var db = Firestore.firestore()
    
    @Published var collectedStampIds: [Int] = []
    
    func loadCollectedStamps() async {
        do {
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            let collectionRef = db
                .collection("users")
                .document(authDataResult.uid)
                .collection("collected_stamps")

            let snapshot = try await collectionRef.getDocuments()
            let ids = snapshot.documents.compactMap { $0["castleId"] as? Int }

            self.collectedStampIds = ids
            print("✅ 收集到的 stamps：\(ids)")
        } catch {
            print("❌ 無法載入使用者收集印章：\(error.localizedDescription)")
        }
    }
    // New
    
    func getAllCastles() async throws {
        self.castles = try await CastleManager.shared.getAllCastles()
    }
    
    func addUserFavoriteCastle(castleId: Int) {
        Task {
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            try? await UserManager.shared.addUserFavoriteCastle(userId: authDataResult.uid, castleId: castleId)
        }
    }
    
    //回傳布林值
    func checkUserFavoriteCastle(castleId: Int) async throws {
        Task {
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            self.isFavorite = try await UserManager.shared.checkUserFavoriteCastle(userId: authDataResult.uid, castleId: castleId)
            //print("CastleViewmodel's func isFav")
            //print(isFavorite)
        }
    }
}

