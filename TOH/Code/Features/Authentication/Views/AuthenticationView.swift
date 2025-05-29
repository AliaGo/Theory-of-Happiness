//
//  AuthenticationView.swift
//  TheoryOfHappiness
//
//  Created by Alia on 2024/12/30.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift
import FirebaseAnalytics




struct AuthenticationView: View {
    @StateObject private var viewModel = AuthenticationViewModel()
    @Binding var showSignInView: Bool
    @State private var showNicknameView = false
    
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
            
            /* 先關掉email登入方法
            NavigationLink{
                SignInEmailView(showSignInView: $showSignInView)
            } label: {
                Text("Sign In with Email")
                    .font(.title2)
                    .foregroundStyle(.black)
                    .frame(height:55)
                    .frame(maxWidth:.infinity)
                    .background(Color.white)
                    .cornerRadius(10)
            }*/
            
            Button {
                Task {
                    do {
                        try await viewModel.signInApple()
                        if viewModel.lackOfNickname {
                            showNicknameView = true
                            print("no nickname")
                        } else {
                            showSignInView = false
                        }
                        
                        
                    } catch {
                        print(error)
                    }
                }
            } label: {
                SignInWithAppleButtonViewRepresentable(type: .default, style: .white)
            }
            .frame(height: 55)
            
            
            GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .light, style: .wide, state: .normal)){
                Task {
                    do {
                        try await viewModel.signInGoogle()
                        showSignInView = false
                        
                        // 追蹤google登入
                        Analytics.logEvent("sign_up", parameters: [
                                        "method": "google"
                                    ])
                    } catch {
                        print(error)
                    }
                }
            }
            
            
            Spacer()
        }
        .padding()
        .background(Color.myGreen1)
        .fullScreenCover(isPresented: $showNicknameView) {
            NicknameSetupView { nickname in
                showNicknameView = false
                showSignInView = false
            }
        }
    }
}

#Preview("Authentication") {
    NavigationStack{
        AuthenticationView(showSignInView: .constant(false))
    }
}
