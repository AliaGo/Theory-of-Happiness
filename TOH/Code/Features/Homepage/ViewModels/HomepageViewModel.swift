//
//  HomepageViewModel.swift
//  TOH
//
//  Created by Alia on 2025/2/6.
//

import Foundation
import FirebaseCore
import FirebaseFirestore


@MainActor
final class HomepageViewModel: ObservableObject {
    
    @Published var castles = [Castle]()
    @Published var ramens = [Ramen]()
    @Published var twRamens = [TWRamen]()
    @Published private(set) var user: DBUser? = nil
    @Published private(set) var castleRank: Int? = nil
    
    private var db = Firestore.firestore()
    
    func loadCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
    }

    var needsClanSelection: Bool {
        user?.samuraiClan?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty != false
    }

    func chooseSamuraiClan(_ clan: SamuraiClan) async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        try await UserManager.shared.chooseSamuraiClan(userId: authDataResult.uid, clan: clan)
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
    }

    /// 與 Profile 和攻城排行榜相同：依不同已攻下城堡數量決定名次。
    func loadCastleRank() async {
        do {
            let auth = try AuthenticationManager.shared.getAuthenticatedUser()
            let visitors = try await db.collectionGroup("visitors").getDocuments()
            let counts = visitors.documents.reduce(into: [String: Int]()) { result, document in
                let userId = document.data()["userId"] as? String ?? document.documentID
                guard !userId.isEmpty else { return }
                result[userId, default: 0] += 1
            }

            guard let myCastleCount = counts[auth.uid], myCastleCount > 0 else {
                castleRank = nil
                return
            }

            castleRank = 1 + counts.values.filter { $0 > myCastleCount }.count
        } catch {
            castleRank = nil
            print("❌ loadCastleRank failed: \(error)")
        }
    }
    
    func fetchData() async throws {
        self.castles = try await CastleManager.shared.getAllCastles()
        self.ramens = try await RamenManager.shared.getAllramens()
        self.twRamens  = try await TWRamenManager.shared.getAllTWRamens()

    }
    
    
    
    
}
