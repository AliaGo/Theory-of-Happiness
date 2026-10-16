//
//  AuthenticationViewModel.swift
//  TOH
//
//  Created by Alia on 2025/1/15.
//

import Foundation
import SwiftUI


@MainActor
final class AuthenticationViewModel: ObservableObject {
    @Published var needsWarriorOnboarding = false
    @Published private(set) var user: DBUser? = nil

    func signInGoogle() async throws {
        let tokens = try await SignInGoogleHelper().signIn()
        let authUser = try await AuthenticationManager.shared.signInWithGoogle(tokens: tokens)
        try await determineMembership(authUser: authUser)
    }

    func signInApple() async throws {
        let tokens = try await SignInAppleHelper().startSignInWithAppleFlow()
        let authUser = try await AuthenticationManager.shared.signInWithApple(tokens: tokens)
        try await determineMembership(authUser: authUser)
    }

    /// users/{uid} 不存在才算新會員；舊會員不會再次看到入門流程。
    private func determineMembership(authUser: AuthDataResultModel) async throws {
        let exists = try await UserManager.shared.userProfileExists(userId: authUser.uid)
        needsWarriorOnboarding = !exists

        if exists {
            user = try? await UserManager.shared.getUser(userId: authUser.uid)
            print("✅ 舊會員登入")
        } else {
            print("🆕 新會員，準備進入武士入門")
        }
    }

    func completeWarriorOnboarding(nickname: String, clan: SamuraiClan) async throws {
        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
        try await UserManager.shared.createWarriorProfile(
            auth: authUser,
            nickname: nickname,
            clan: clan
        )
        user = try await UserManager.shared.getUser(userId: authUser.uid)
        needsWarriorOnboarding = false
    }
}


