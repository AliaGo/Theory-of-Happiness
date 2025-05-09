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
    
    private var db = Firestore.firestore()
    
    func loadCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
    }
    
    func fetchData() async throws {
        self.castles = try await CastleManager.shared.getAllCastles()
        self.ramens = try await RamenManager.shared.getAllramens()
        self.twRamens  = try await TWRamenManager.shared.getAllTWRamens()

    }
    
    
    
    
}
