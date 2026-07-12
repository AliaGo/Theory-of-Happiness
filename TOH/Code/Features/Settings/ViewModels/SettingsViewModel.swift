//
//  SettingsViewModel.swift
//  TheoryOfHappiness
//
//  Created by Alia on 2025/1/4.
//

import Foundation
import SwiftUI
import Photos
import PhotosUI
import Firebase

@MainActor
final class SettingsViewModel: ObservableObject {
    
    @Published var authProviders: [AuthProviderOption] = []
    @Published private(set) var user: DBUser? = nil
    @Published var selectedItem: PhotosPickerItem? = nil
    
    @StateObject private var userSession = UserSession()
    
    func loadAuthProviders() {
        if let providers = try? AuthenticationManager.shared.getProviders() {
            authProviders = providers
        }
    }
    
    func loadCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
    }
    

    func saveProfileImage(item: PhotosPickerItem) {
        guard let user else { return }

        Task {
            do {
                try await requestPhotoPermissionIfNeeded()
                
                guard let asset = try await item.getPHAsset() else {
                    print("❌ 無法取得 PHAsset")
                    return
                }

                let data = try await asset.loadImageData()

                let (path, _) = try await StorageManager.shared.saveImage(
                    data: data,
                    userId: user.userId
                )

                let url = try await StorageManager.shared.getUrlForImage(path: path)

                try await UserManager.shared.updateUserProfileImagePath(
                    userId: user.userId,
                    path: path,
                    url: url.absoluteString
                )

                print("✅ Profile image uploaded")

            } catch {
                print("❌ 上傳失敗:", error)
            }
        }
    }

    func requestPhotoPermissionIfNeeded() async throws {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)

        if status == .notDetermined {
            let newStatus = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
            if newStatus != .authorized && newStatus != .limited {
                throw NSError(domain: "PhotoPermission", code: 1)
            }
        } else if status != .authorized && status != .limited {
            throw NSError(domain: "PhotoPermission", code: 2)
        }
    }

    
    func deleteProfileImage() {
        guard let user, let path = user.profileImagePath else { return }
        
        Task {
            try await StorageManager.shared.deleteImage(path: path)
            try await UserManager.shared.updateUserProfileImagePath(userId: user.userId, path: nil, url: nil)
        }
    }
    
    func signOut() throws {
        try AuthenticationManager.shared.signOut()
    }
    
    func resetPassword() async throws {
        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
        
        guard let email = authUser.email else {
            throw URLError(.fileDoesNotExist)
        }
        
        try await AuthenticationManager.shared.resetPassword(email: email)
    }
    
    func updateEmail() async throws {
        let email = "aliaShigeno@gmail.com"
        try await AuthenticationManager.shared.updateEmail(email: email)
    }
    
    func updatePassword() async throws {
        let password = "aliaShigeno"
        try await AuthenticationManager.shared.updatePassword(password: password)
    }
    
    func updateUserNickname(userNickname: String) async throws {
        guard let user else { return }
        
        try await UserManager.shared.updateUserNickname(userId: user.userId, userNickname: userNickname)
        
    }
    
    func deleteAccount() async throws {
        try await UserManager.shared.deleteAccount()
        userSession.status = .unauthenticated
    }
    
}


extension PhotosPickerItem {
    func getPHAsset() async throws -> PHAsset? {
        let identifiers = self.itemIdentifier
        guard let id = identifiers else { return nil }

        let assets = PHAsset.fetchAssets(withLocalIdentifiers: [id], options: nil)
        return assets.firstObject
    }
}

extension PHAsset {
    func loadImageData() async throws -> Data {
        try await withCheckedThrowingContinuation { continuation in
            let options = PHImageRequestOptions()
            options.isNetworkAccessAllowed = true   // ⭐⭐⭐ 關鍵
            options.deliveryMode = .highQualityFormat
            options.isSynchronous = false

            PHImageManager.default().requestImageDataAndOrientation(
                for: self,
                options: options
            ) { data, _, _, info in
                if let error = info?[PHImageErrorKey] as? Error {
                    continuation.resume(throwing: error)
                } else if let data {
                    continuation.resume(returning: data)
                } else {
                    continuation.resume(throwing: NSError(
                        domain: "ImageError",
                        code: -1,
                        userInfo: [NSLocalizedDescriptionKey: "Image data is nil"]
                    ))
                }
            }
        }
    }
}
