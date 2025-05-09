//
//  RootView.swift
//  TheoryOfHappiness
//
//  Created by Alia on 2025/1/4.
//

import SwiftUI

struct RootView: View {
    
    @State private var showSignInView:Bool = false
    
    var body: some View {
        ZStack{
            if !showSignInView {
                ContentView(showSignInView: $showSignInView).environment(ModelData())
            }
            
        }
        .onAppear {
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.showSignInView = authUser == nil // ? true : false
            
        }
        .fullScreenCover(isPresented: $showSignInView) {
            NavigationStack {
                AuthenticationView(showSignInView: $showSignInView)
            }
        }
    }
}

#Preview {
    RootView()
}
