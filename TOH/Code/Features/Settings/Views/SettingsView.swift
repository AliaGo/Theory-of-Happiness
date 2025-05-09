//
//  SettingsView.swift
//  TheoryOfHappiness
//
//  Created by Alia on 2025/1/4.
//

import SwiftUI

struct SettingsView: View {
    
    @StateObject private var viewModel = SettingsViewModel()
    @Binding var showSignInView: Bool
    
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
                        try viewModel.signOut()
                        showSignInView = true
                    } catch {
                        print(error)
                    }
                }
            }
            .foregroundColor(.red)
            
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
            HStack{
                Image(systemName: "person")
                TextField("enter your nickname" , text: $userNickname)
            }
            /*
            HStack{
                Image(systemName: "globe")
                Picker(selection: $languageIndex, label: Text("Language")) {
                    ForEach(0 ..< languageOptions.count) {
                        Text(self.languageOptions[$0])
                    }
                }
                /*
                .onChange(of: languageIndex) { newValue in
                    // 根據選擇的語言更新 App 語言
                    setAppLanguage(language: newValue)
                }
                */
            }
            HStack{
                Image(systemName: "moon.circle.fill")
                Toggle(isOn: $isDarkMode) {
                    Text("Dark Mode")
                }.onChange(of: isDarkMode) { value in
                    // 這會讓 dark mode 生效
                    UIApplication.shared.windows.first?.rootViewController?.view.overrideUserInterfaceStyle = value ? .dark : .light
                }
            }
            
            HStack{
                Image(systemName: "textformat")
                Picker(selection: $fontIndex, label: Text("Font Size")) {
                    ForEach(0 ..< fontOptions.count) {
                        Text(self.fontOptions[$0])
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
             */
            HStack{
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


