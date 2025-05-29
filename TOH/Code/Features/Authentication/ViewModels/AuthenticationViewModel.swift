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
    
    @Published var lackOfNickname: Bool = false
    @Published private(set) var user: DBUser? = nil
    
    let signInAppleHelper = SignInAppleHelper()
    
    func signInGoogle() async throws {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        let authDataResult = try await AuthenticationManager.shared.signInWithGoogle(tokens: tokens)
        print("✅ Signed in with Firebase:", authDataResult)
        try await UserManager.shared.checkIfUserExist(user: authDataResult)
        print("✅ Checked or created user in Firestore")
        
    }
    
    func signInApple() async throws {
        let helper = SignInAppleHelper()
        let tokens = try await helper.startSignInWithAppleFlow()
        try await AuthenticationManager.shared.signInWithApple(tokens: tokens)
        
        print("檢查檢查")
        // 這邊確認是否為首次登入，或 nickname 為 nil
        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
        
        // 建立 Firestore 使用者資料（若尚未建立）
        try await UserManager.shared.checkIfUserExist(user: authUser)
        print("✅ Checked or created user in Firestore")
        
        do {
            let existingUser = try await UserManager.shared.getUser(userId: authUser.uid)
            self.user = existingUser
            lackOfNickname = existingUser.userNickname?.isEmpty != false
            print("賦予lackOfNickname值")
        } catch {
            lackOfNickname = true
        }

        print("登入成功，缺少 nickname: \(lackOfNickname)")
        
    }
    
    /*
    func signInAppleAndCheckNickname() async throws {
        print("開始檢查 nickname")
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
        print("get user")
        let nickname = user?.userNickname

        print("檢查nickname")
        if nickname?.isEmpty != false {
            // nickname 是 nil 或是空字串 ""，都會進入這裡
            lackOfNickname = true
        } else {
            lackOfNickname = false
        }
    }*/
    
    func updateUserNickname(userId: String, userNickname: String) async throws {
        
        print("使用者ID: \(userId)")
        try await UserManager.shared.updateUserNickname(userId: userId, userNickname: userNickname)
        
    }
}



