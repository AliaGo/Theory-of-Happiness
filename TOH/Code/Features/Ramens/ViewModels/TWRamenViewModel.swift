//
//  TaiwanRamenViewModel.swift
//  TOH
//
//  Created by Alia on 2025/5/6.
//

import Foundation
import SwiftUI

@MainActor
final class TWRamenViewModel: ObservableObject {
    
    @Published private(set) var twRamens = [TWRamen]()
    @Published private(set) var isFavorite: Bool = false
    
    func getAllRamens() async throws {
        self.twRamens = try await TWRamenManager.shared.getAllTWRamens()
    }
    
    func addUserFavoriteTWRamen(ramenId: String) {
        Task {
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            try? await UserManager.shared.addUserFavoriteTWRamen(userId: authDataResult.uid, ramenId: ramenId)
        }
    }
    
    //回傳布林值
    func checkUserFavoriteRamen(ramenId: String) async throws {
        Task {
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            self.isFavorite = try await UserManager.shared.checkUserFavoriteTWRamen(userId: authDataResult.uid, ramenId: ramenId)
            //print("RamenViewmodel's func isFav")
            //print(isFavorite)
        }
    }
    
}

