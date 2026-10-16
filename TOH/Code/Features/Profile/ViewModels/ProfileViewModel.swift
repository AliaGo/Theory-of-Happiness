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
import FirebaseFirestore

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
    @Published private(set) var castleVisits: [UserCastleVisit] = []
    @Published private(set) var castleRank: Int? = nil
    
    @Published var castlePostCount: Int = 0
    @Published var ramenPostCount: Int = 0
    
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
            do {
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

    func loadCastleVisits() async {
        do {
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            castleVisits = try await UserManager.shared.getAllUserCastleVisits(userId: authDataResult.uid)
        } catch {
            print("❌ loadCastleVisits failed: \(error)")
        }
    }

    /// 與攻城排行榜採用相同規則：已攻下的不同城堡數越多，排名越前面。
    func loadCastleRank() async {
        guard !castleVisits.isEmpty else {
            castleRank = nil
            return
        }

        do {
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            let visitors = try await Firestore.firestore().collectionGroup("visitors").getDocuments()
            let counts = visitors.documents.reduce(into: [String: Int]()) { result, document in
                let userId = document.data()["userId"] as? String ?? document.documentID
                guard !userId.isEmpty else { return }
                result[userId, default: 0] += 1
            }

            guard let myCastleCount = counts[authDataResult.uid], myCastleCount > 0 else {
                castleRank = nil
                return
            }

            castleRank = 1 + counts.values.filter { $0 > myCastleCount }.count
        } catch {
            castleRank = nil
            print("❌ loadCastleRank failed: \(error)")
        }
    }
    
    func loadPostCounts(userId: String) async {
        do {
            async let castle = PostManager.shared.getPostCount(
                userId: userId,
                type: "castle"
            )
            async let ramen = PostManager.shared.getPostCount(
                userId: userId,
                type: "ramen"
            )

            let (castleCount, ramenCount) = try await (castle, ramen)

            self.castlePostCount = castleCount
            self.ramenPostCount = ramenCount
        } catch {
            print("❌ loadPostCounts failed:", error)
        }
    }

}
