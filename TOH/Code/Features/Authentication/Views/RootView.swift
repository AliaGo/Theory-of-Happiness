//
//  RootView.swift
//  TheoryOfHappiness
//
//  Created by Alia on 2025/1/4.
//

import SwiftUI

struct RootView: View {
    @StateObject private var userSession = UserSession()
    
    var body: some View {
        ZStack {
            if userSession.status == .authenticated || userSession.status == .guest {
                ContentView()
                    .environmentObject(userSession)
                    .environment(ModelData())
            }
        }
        .fullScreenCover(isPresented: Binding(
                    get: {
                // 只有當 status 是 unknown 或 unauthenticated 時才顯示登入畫面
                userSession.status == .unknown || userSession.status == .unauthenticated
            },
            set: { _ in }
        )) {
            NavigationStack {
                AuthenticationView(allowGuest: true)
                    .environmentObject(userSession)
            }
        }
        .onAppear {
            userSession.updateAuthStatus()
        }
        
    }
}

#Preview {
    RootView()
}
