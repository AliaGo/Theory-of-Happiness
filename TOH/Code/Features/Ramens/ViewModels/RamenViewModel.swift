//
//  RamenViewModel.swift
//  TOH
//
//  Created by Alia on 2025/2/6.
//

import Foundation
import SwiftUI

@MainActor
final class RamenViewModel: ObservableObject {
    
    @Published private(set) var ramens = [Ramen]()
    @Published private(set) var isFavorite: Bool = false
    
    func getAllRamens() async throws {
        self.ramens = try await RamenManager.shared.getAllramens()
    }
    
    func addUserFavoriteRamen(ramenId: Int) {
        Task {
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            try? await UserManager.shared.addUserFavoriteRamen(userId: authDataResult.uid, ramenId: ramenId)
        }
    }
    
    //回傳布林值
    func checkUserFavoriteRamen(ramenId: Int) async throws {
        Task {
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            self.isFavorite = try await UserManager.shared.checkUserFavoriteRamen(userId: authDataResult.uid, ramenId: ramenId)
            //print("RamenViewmodel's func isFav")
            //print(isFavorite)
        }
    }
    
}
