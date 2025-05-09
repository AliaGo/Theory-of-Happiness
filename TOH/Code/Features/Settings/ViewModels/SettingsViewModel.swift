//
//  SettingsViewModel.swift
//  TheoryOfHappiness
//
//  Created by Alia on 2025/1/4.
//

import Foundation
import SwiftUI

@MainActor
final class SettingsViewModel: ObservableObject {
    
    @Published var authProviders: [AuthProviderOption] = []
    @Published private(set) var user: DBUser? = nil
    
    func loadAuthProviders() {
        if let providers = try? AuthenticationManager.shared.getProviders() {
            authProviders = providers
        }
    }
    
    func loadCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
    }
    
    func signOut() throws {
        try AuthenticationManager.shared.signOut()
    }
    
    func resetPassword() async throws {
        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
        
        guard let email = authUser.email else {
            throw URLError(.fileDoesNotExist)
        }
        
        try await AuthenticationManager.shared.resetPassword(email: email)
    }
    
    func updateEmail() async throws {
        let email = "aliaShigeno@gmail.com"
        try await AuthenticationManager.shared.updateEmail(email: email)
    }
    
    func updatePassword() async throws {
        let password = "aliaShigeno"
        try await AuthenticationManager.shared.updatePassword(password: password)
    }
    
    func updateUserNickname(userNickname: String) async throws {
        guard let user else { return }
        
        try await UserManager.shared.updateUserNickname(userId: user.userId, userNickname: userNickname)
        
    }
    
}
