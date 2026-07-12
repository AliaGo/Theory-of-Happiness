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
    var allowGuest: Bool = true // 預設允許跳過
    
    @StateObject private var viewModel = AuthenticationViewModel()
    //@Binding var showSignInView: Bool
    @EnvironmentObject var userSession: UserSession
    @Environment(\.dismiss) private var dismiss     // 讓自己能關閉
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
                            userSession.status = .authenticated // 標記已登入
                            dismiss() // 關閉登入畫面
                        }
                        
                        
                    } catch {
                        print(error)
                    }
                }
            } label: {
                SignInWithAppleButtonViewRepresentable(type: .default, style: .white)
                    .frame(maxWidth: .infinity, maxHeight: 45) // 統一寬高
            }
            
            
            GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .light, style: .wide, state: .normal)){
                Task {
                    do {
                        try await viewModel.signInGoogle()
                        userSession.status = .authenticated
                        dismiss()
                        
                        // 追蹤google登入
                        Analytics.logEvent("sign_up", parameters: [
                                        "method": "google"
                                    ])
                    } catch {
                        print(error)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 45) // 統一寬高
            
            if allowGuest {
                Text("Wanna Browse Without Sign In First?")
                    .font(.caption)
                    .underline()
                    .foregroundColor(.white)
                    .padding(.top, 8)
                
                Button{
                    userSession.status = .guest
                    dismiss()
                } label: {
                    Text("Browse as a Guest")
                        .fontWeight(.medium)
                        .frame(maxWidth: .infinity, maxHeight: 45)
                        .foregroundColor(.gray)    // 黑字
                        .background(Color.white)    // 白底
                        .cornerRadius(6)           // 圓角
                        .padding(.horizontal)       // 左右邊距
                }
                
            }
            
            
            Spacer()
        }
        .padding()
        .background(Color.myGreen1)
        .fullScreenCover(isPresented: $showNicknameView) {
            NicknameSetupView { nickname in
                showNicknameView = false
                userSession.status = .authenticated
                dismiss()
            }
        }
    }
}


