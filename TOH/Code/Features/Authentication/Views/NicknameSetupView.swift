//
//  NicknameSetupView.swift
//  TOH
//
//  Created by Alia on 2025/5/20.
//

import SwiftUI

struct NicknameSetupView: View {
    @StateObject private var viewModel = AuthenticationViewModel()
    @State private var nickname: String = ""
    @State private var showError: Bool = false
    @State private var isSubmitting: Bool = false

    let onComplete: (String) -> Void   // 傳入 closure

    var body: some View {
        VStack(spacing: 30) {
            Text("歡迎加入！")
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)

            Text("請設定一個您的專屬暱稱")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)

            TextField("輸入暱稱", text: $nickname)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(showError ? Color.red : Color.clear, lineWidth: 1)
                )
                .padding(.horizontal)

            if showError {
                Text("暱稱不能為空")
                    .foregroundColor(.red)
                    .font(.footnote)
            }

            Button {
                Task {
                    showError = nickname.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                    guard !showError else { return }

                    isSubmitting = true
                    // 先存入 Firestore
                    do {
                        let userId = try AuthenticationManager.shared.getAuthenticatedUser().uid
                        print("現在要更改暱稱的使用者id爲：\(userId)")

                        try await viewModel.updateUserNickname(userId: userId, userNickname: nickname)

                        onComplete(nickname)
                        print("更改nickname成功")
                    } catch {
                        print("取得使用者ID或更新暱稱失敗: \(error)")
                    }
                    isSubmitting = false
                }
            } label: {
                Text("完成")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .font(.headline)
            }
            .padding(.horizontal)
            .disabled(isSubmitting)
        }
        .padding()
    }
}

#Preview {
    NicknameSetupView { nickname in
            print("Nickname entered: \(nickname)")
        }
}
