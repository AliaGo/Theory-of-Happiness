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
    
    @State var userNickname: String = ""
    @State var isDarkModeEnabled: Bool = true
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

#Preview {
    NavigationStack{
        SettingsView(showSignInView: .constant(false))
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
            
            HStack{
                Image(systemName: "globe")
                Picker(selection: $languageIndex, label: Text("Language")) {
                    ForEach(0 ..< languageOptions.count) {
                        Text(self.languageOptions[$0])
                    }
                }
                
            }
            HStack{
                Image(systemName: "moon.circle.fill")
                Toggle(isOn: $isDarkModeEnabled) {
                    Text("Dark Mode")
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
}

