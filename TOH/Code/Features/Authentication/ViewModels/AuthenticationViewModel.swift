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
    
    func signInGoogle() async throws {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        let authDataResult = try await AuthenticationManager.shared.signInWithGoogle(tokens: tokens)
        print("✅ Signed in with Firebase:", authDataResult)
        try await UserManager.shared.checkIfUserExist(user: authDataResult)
        print("✅ Checked or created user in Firestore")
        /*
        let user = DBUser(auth: authDataResult)
        try await UserManager.shared.createNewUser(user: user)
         */
    }
}
