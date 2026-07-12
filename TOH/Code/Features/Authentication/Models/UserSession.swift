//
//  UserSession.swift
//  TOH
//
//  Created by Alia on 2025/6/7.
//
import Foundation
import Combine

class UserSession: ObservableObject {
    
    enum AuthStatus {
        case unknown        // 初始狀態，還沒檢查登入
        case unauthenticated // 明確未登入
        case guest          // 訪客
        case authenticated  // 已登入使用者
    }
    
    @Published var status: AuthStatus = .guest  // 預設為訪客
    
    var isSignedIn: Bool {
        if case .authenticated = status {
            return true
        }
        return false
    }
    
    //@Published var isSignedIn: Bool = false
    
    func updateAuthStatus() {
        if let user = try? AuthenticationManager.shared.getAuthenticatedUser() {
            self.status = .authenticated
        } else {
            self.status = .guest
        }
        /*
        let user = try? AuthenticationManager.shared.getAuthenticatedUser()
        self.isSignedIn = user != nil
         */
    }
    
    func signOut() {
        try? AuthenticationManager.shared.signOut()
        self.status = .guest
    }
}

