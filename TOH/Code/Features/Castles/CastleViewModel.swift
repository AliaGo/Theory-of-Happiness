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
    @Published private(set) var hasVisited: Bool = false
    @Published private(set) var visit: UserCastleVisit?
    @Published private(set) var communityStats = CastleCommunityStats()
    @Published private(set) var favoriteCastleIds: Set<Int> = []
    @Published private(set) var visitedCastleIds: Set<Int> = []
    private var castleVisitsListener: ListenerRegistration?
    
    // New
    private var db = Firestore.firestore()

    deinit {
        castleVisitsListener?.remove()
    }
    
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

    func loadCastleCollectionFilters() async {
        do {
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            let favoriteCastles = try await UserManager.shared.getAllUserFavoriteCastles(userId: authDataResult.uid)
            favoriteCastleIds = Set(favoriteCastles.map(\.castleId))
            observeCastleVisits(userId: authDataResult.uid)
        } catch {
            // Explore is also available before sign-in; in that case only the all-castles filter has results.
            castleVisitsListener?.remove()
            castleVisitsListener = nil
            favoriteCastleIds = []
            visitedCastleIds = []
        }
    }

    /// 讓 Explore 的「已攻下」篩選和攻城紀錄保持即時同步。
    private func observeCastleVisits(userId: String) {
        castleVisitsListener?.remove()
        castleVisitsListener = db
            .collection("users")
            .document(userId)
            .collection("castle_visits")
            .addSnapshotListener { [weak self] snapshot, error in
                guard error == nil else { return }
                let ids = snapshot?.documents.compactMap { $0.data()["castleId"] as? Int } ?? []
                Task { @MainActor [weak self] in
                    self?.visitedCastleIds = Set(ids)
                }
            }
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

    func loadVisitStatus(castleId: Int) async {
        do {
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            visit = try await UserManager.shared.getUserCastleVisit(userId: authDataResult.uid, castleId: castleId)
            hasVisited = visit != nil
        } catch {
            print("❌ loadVisitStatus failed: \(error)")
        }
    }

    func saveVisit(
        castle: Castle,
        visitedDate: Date,
        visitType: CastleVisitType,
        recommendationRating: Int,
        difficultyRating: Int,
        note: String
    ) {
        Task {
            do {
                let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
                try await UserManager.shared.recordCastleVisit(
                    userId: authDataResult.uid,
                    castleId: castle.id,
                    castleName: castle.name,
                    visitedDate: visitedDate,
                    visitType: visitType,
                    recommendationRating: recommendationRating,
                    difficultyRating: difficultyRating,
                    note: note
                )
                await loadVisitStatus(castleId: castle.id)
                await loadCommunityStats(castleId: castle.id)
            } catch {
                print("❌ saveVisit failed: \(error)")
            }
        }
    }

    func removeVisit(castleId: Int) {
        Task {
            do {
                let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
                try await UserManager.shared.removeCastleVisit(userId: authDataResult.uid, castleId: castleId)
                visit = nil
                hasVisited = false
                await loadCommunityStats(castleId: castleId)
            } catch {
                print("❌ removeVisit failed: \(error)")
            }
        }
    }

    func loadCommunityStats(castleId: Int) async {
        do {
            let db = Firestore.firestore()
            async let visitors = db.collection("castles").document(String(castleId)).collection("visitors").getDocuments()
            async let ratings = db.collection("castles").document(String(castleId)).collection("ratings").getDocuments()
            let (visitorSnapshot, ratingSnapshot) = try await (visitors, ratings)
            let recommendationRatings = ratingSnapshot.documents.compactMap { $0.data()["recommendationRating"] as? Int }
            let difficultyRatings = ratingSnapshot.documents.compactMap { $0.data()["difficultyRating"] as? Int }
            communityStats = CastleCommunityStats(
                visitCount: visitorSnapshot.documents.count,
                recommendationAverage: recommendationRatings.average,
                difficultyAverage: difficultyRatings.average
            )
        } catch {
            print("❌ loadCommunityStats failed: \(error)")
        }
    }
}

struct CastleCommunityStats {
    var visitCount = 0
    var recommendationAverage: Double?
    var difficultyAverage: Double?
}

private extension Array where Element == Int {
    var average: Double? {
        guard !isEmpty else { return nil }
        return Double(reduce(0, +)) / Double(count)
    }
}
