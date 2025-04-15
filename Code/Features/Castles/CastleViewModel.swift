//
//  CastleViewModel.swift
//  TOH
//
//  Created by Alia on 2025/2/6.
//

import Foundation
import SwiftUI

@MainActor
final class CastleViewModel: ObservableObject {
    
    @Published private(set) var castles: [Castle] = []
    @Published private(set) var isFavorite: Bool = false
    
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


