//
//  ProfileViewModel.swift
//  TOH
//
//  Created by Alia on 2025/2/6.
//

import Foundation
import SwiftUI
import PhotosUI
import Firebase

struct Profile {
    var username: String
    var email: String
    var birthday = Date()
    var phone: String
    var address: String
    


    static let `default` = Profile(username: "Alia", email: "aliaShigeno@gmail.com", phone: "08012345678", address: "日本大阪")

}

@MainActor
final class ProfileViewModel: ObservableObject {
    
    @Published private(set) var user: DBUser? = nil
    @Published private(set) var userCollectedStamps: [UserCollectedStamps]? = nil
    
    func loadCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
    }
    
    func togglePremiumStatus() {
        guard let user else { return }
        let currentValue = user.isPremium ?? false
        Task{
            try await UserManager.shared.updateUserPremiumStatus(userId: user.userId, isPremium: !currentValue)
            self.user = try await UserManager.shared.getUser(userId: user.userId)
        }
        
    }
    
    func saveProfileImage(item: PhotosPickerItem) {
        guard let user else { return }
        
        Task {
            guard let data = try await item.loadTransferable(type: Data.self) else { return }
            let (path, name) = try await StorageManager.shared.saveImage(data: data, userId: user.userId)
            print("Success")
            print(path + "   " + name)
            let url = try await StorageManager.shared.getUrlForImage(path: path)
            try await UserManager.shared.updateUserProfileImagePath(userId: user.userId, path: path, url: url.absoluteString)
        }
    }
    
    func deleteProfileImage() {
        guard let user, let path = user.profileImagePath else { return }
        
        Task {
            try await StorageManager.shared.deleteImage(path: path)
            try await UserManager.shared.updateUserProfileImagePath(userId: user.userId, path: nil, url: nil)
        }
    }
    
    func formatDate(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        formatter.timeZone = TimeZone(secondsFromGMT: 8 * 3600)
        formatter.locale = Locale(identifier: "zh_TW")
        return formatter.string(from: date)
    }

    // 給 View 用
    var formattedDateCreated: String {
        guard let dateCreated = user?.dateCreated else { return "" }
        return formatDate(from: dateCreated)
    }
    
    func getCollectedStamps() async {
        Task{
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            self.userCollectedStamps = try await UserManager.shared.getAllUserCollectedStamps(userId:authDataResult.uid)
        }
        
    }

}


