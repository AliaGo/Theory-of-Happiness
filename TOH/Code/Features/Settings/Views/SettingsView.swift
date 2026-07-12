//
//  SettingsView.swift
//  TheoryOfHappiness
//
//  Created by Alia on 2025/1/4.
//

import SwiftUI
import PhotosUI

struct SettingsView: View {
    
    @StateObject private var viewModel = SettingsViewModel()
    //@Binding var showSignInView: Bool
    @EnvironmentObject var userSession: UserSession
    
    @State private var showConfirmationDialog = false
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    
    @State var userNickname: String
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @State var isNotificationEnabled: Bool = true
    
    @State private var languageIndex = 0
    var languageOptions = ["Chinese", "English", "Japanese"]
    
    @State private var fontIndex = 0
    var fontOptions = ["Default", "Large"]
    
    var body: some View {
        List {
            infoSection
            
            Button("Log Out") {
                Task{
                    do {
                        //try viewModel.signOut()
                        //showSignInView = true
                        
                        userSession.signOut()
                    } catch {
                        print(error)
                    }
                }
            }
            .foregroundColor(.red)
            
            Button(role: .destructive) {
                showConfirmationDialog = true
            } label: {
                Text("刪除帳號")
            }
            
            if viewModel.authProviders.contains(.email) {
                emailSection
            }
            
        }
        .onAppear {
            viewModel.loadAuthProviders()
        }
        .task{
            try? await viewModel.loadCurrentUser()
        }
        .navigationBarTitle("Settings")
        .confirmationDialog("確定要刪除帳號嗎？此操作無法復原。", isPresented: $showConfirmationDialog) {
            Button("永久刪除", role: .destructive) {
                Task {
                    do {
                        try await viewModel.deleteAccount()
                        // 登出或跳回登入頁面
                        userSession.signOut() // 這行新增
                    } catch {
                        errorMessage = error.localizedDescription
                        showErrorAlert = true
                    }
                }
            }
            Button("取消", role: .cancel) {}
        }
        .alert("刪除失敗", isPresented: $showErrorAlert) {
            Button("確定", role: .cancel) {}
        } message: {
            Text(errorMessage)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    Task{
                        do {
                            try await viewModel.updateUserNickname(userNickname: userNickname)
                        } catch {
                            print(error)
                        }
                    }
                }
            }
        }
    }
}

extension SettingsView {
    
    private var emailSection: some View {
        Section {
            Button("Reset Password") {
                Task{
                    do {
                        try await viewModel.resetPassword()
                        print("PASSWORD RESET")
                    } catch {
                        print(error)
                    }
                }
            }
            
            Button("Update Password") {
                Task{
                    do {
                        try await viewModel.updatePassword()
                        print("PASSWORD UPDATED")
                    } catch {
                        print(error)
                    }
                }
            }
            
            Button("Update Email") {
                Task{
                    do {
                        try await viewModel.updateEmail()
                        print("EMAIL UPDATED")
                    } catch {
                        print(error)
                    }
                }
            }
        } header: {
            Text("Email Functions")
        }
    }
}

extension SettingsView {
    
    
    private var infoSection: some View {
        Section {
            HStack {
                // 顯示大頭貼
                if let imageUrl = viewModel.user?.profileImagePathUrl, let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image.resizable()
                                 .scaledToFill()
                                 .frame(width: 80, height: 80)
                                 .clipShape(Circle())
                        default:
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .frame(width: 80, height: 80)
                                .foregroundColor(.gray)
                        }
                    }
                } else {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.gray)
                }

                // PhotosPicker 選大頭貼
                PhotosPicker(
                    selection: $viewModel.selectedItem,
                    matching: .images,
                    photoLibrary: .shared()
                ) {
                    Text("更換大頭貼")
                }
                .onChange(of: viewModel.selectedItem) { newItem in
                    if let item = newItem {
                        viewModel.saveProfileImage(item: item)
                    }
                }

                // 刪除大頭貼按鈕
                if viewModel.user?.profileImagePath != nil {
                    Button {
                        viewModel.deleteProfileImage()
                    } label: {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                }
            }

            // 暱稱輸入
            HStack {
                Image(systemName: "person")
                TextField("enter your nickname", text: $userNickname)
            }

            // 通知開關
            HStack {
                Image(systemName: "bell")
                Toggle(isOn: $isNotificationEnabled) {
                    Text("Notification")
                }
            }

        } header: {
            Text("Personal info")
        }
    }

    
    // 更新語言
    func setAppLanguage(language: String) {
        UserDefaults.standard.set([language], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        // 這會讓應用程序在不重啟的情況下更改語言
        // 需要觸發界面更新，可能需要手動重啟某些視圖
    }
}


