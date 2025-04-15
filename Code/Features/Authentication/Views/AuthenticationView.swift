//
//  AuthenticationView.swift
//  TheoryOfHappiness
//
//  Created by Alia on 2024/12/30.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

struct AuthenticationView: View {
    @StateObject private var viewModel = AuthenticationViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        VStack{
            Spacer()
            
            Image("Launching logo")
                .resizable()
                .scaledToFit()
                .frame(minWidth: 0, maxWidth: 200, minHeight: 0, maxHeight: 200)
                .padding(.vertical, 30)
            
            Text("Theory of Happiness")
                .fontWeight(.medium)
                .font(.custom("JacquesFrancoisShadow-Regular", size: 30))
                .foregroundStyle(.white)
            
            NavigationLink{
                SignInEmailView(showSignInView: $showSignInView)
            } label: {
                Text("Sign In with Email")
                    .font(.headline)
                    .foregroundStyle(.black)
                    .frame(height:55)
                    .frame(maxWidth:.infinity)
                    .background(Color.white)
                    .cornerRadius(10)
            }
            
            GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .light, style: .wide, state: .normal)){
                Task {
                    do {
                        try await viewModel.signInGoogle()
                        showSignInView = false
                    } catch {
                        print(error)
                    }
                }
            }
            
            Spacer()
        }
        .padding()
        .background(Color.myGreen1)
    }
}

#Preview("Authentication") {
    NavigationStack{
        AuthenticationView(showSignInView: .constant(false))
    }
}
