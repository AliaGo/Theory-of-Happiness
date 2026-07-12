//
//  StoryViewModel.swift
//  TOH
//
//  Created by Alia on 2025/3/14.
//

import Foundation
import SwiftUI
import PhotosUI
import FirebaseFirestore
import FirebaseAnalytics
import CoreLocation
import ImageIO
import UniformTypeIdentifiers

@MainActor
final class StoViewModel: ObservableObject {
    
    @Published var posts: [Post]?
    @Published private(set) var user: DBUser? = nil
    
    // errors
    @Published var alertMsg = ""
    @Published var showAlert = false
    
    @Published var selectedImage: UIImage? // 存本地圖片
    @Published var selectedImagePickerItem: PhotosPickerItem? // 用來儲存選擇的 PhotosPickerItem
    
    // 照片資訊（拍攝時間跟地點）
    @Published var photoDate: Date?
    @Published private var photoLocation: CLLocation?
    @Published private var address: String? = nil
    
    @Published var createPost: Bool = false
    @Published var isWriting = false
    
    // ➤ Loading 狀態，用於 iCloud 照片下載
    @Published var isImageLoading: Bool = false
    
    // 用來控制是否顯示獲得獎勵對話框
    @Published var showResultDialog: Bool = false
    // 獲得的印章資料（若是 castle 類型）
    @Published var earnedStamp: String? = nil
    // 拉麵類型貼文則顯示點數和文字訊息
    @Published var earnedPointMessage: String? = nil
    
    // MARK: - Fetch Posts
    func fetchPosts() {
        Task {
            do {
                let posts = try await PostManager.shared.getAllposts()
                DispatchQueue.main.async {
                    self.posts = posts
                }
            } catch {
                print("Error fetching posts: \(error)")
            }
        }
    }
    
    // MARK: - Load Current User
    func loadCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
    }
    
    // MARK: - Delete Post
    func deletePost(post: Post) {
        guard let _ = posts else { return }
        let index = posts?.firstIndex(where: { $0.id == post.id }) ?? 0
        // withAnimation { posts?.remove(at: index) }
    }
    
    // MARK: - Format Date
    func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: date)
    }
    
    // MARK: - Select Image (支援 iCloud + Loading)
    func selectImage(item: PhotosPickerItem) {
        Task {
            await MainActor.run { self.isImageLoading = true }

            do {
                guard let data = try await item.loadTransferable(type: Data.self),
                      let image = UIImage(data: data) else {
                    print("❌ 選圖失敗或資料無效")
                    await MainActor.run { self.isImageLoading = false }
                    return
                }
                
                // 解析 Metadata
                parseImageMetadata(data)

                await MainActor.run {
                    self.selectedImage = image
                    self.isImageLoading = false
                    print("✅ selectedImage 已設定")
                }

            } catch {
                print("❌ 圖片下載失敗: \(error)")
                await MainActor.run { self.isImageLoading = false }
            }
        }
    }
    
    // MARK: - Metadata 解析
    private func parseImageMetadata(_ data: Data) {
        if let imageSource = CGImageSourceCreateWithData(data as CFData, nil),
           let metadata = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as? [CFString: Any] {
            
            // 日期
            if let tiffDict = metadata[kCGImagePropertyTIFFDictionary] as? [CFString: Any],
               let dateString = tiffDict[kCGImagePropertyTIFFDateTime] as? String {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy:MM:dd HH:mm:ss"
                self.photoDate = formatter.date(from: dateString)
            }
            
            // GPS
            if let gpsDict = metadata[kCGImagePropertyGPSDictionary] as? [CFString: Any],
               let lat = gpsDict[kCGImagePropertyGPSLatitude] as? Double,
               let latRef = gpsDict[kCGImagePropertyGPSLatitudeRef] as? String,
               let lon = gpsDict[kCGImagePropertyGPSLongitude] as? Double,
               let lonRef = gpsDict[kCGImagePropertyGPSLongitudeRef] as? String {
                
                let latitude = (latRef == "S") ? -lat : lat
                let longitude = (lonRef == "W") ? -lon : lon
                let location = CLLocation(latitude: latitude, longitude: longitude)
                self.photoLocation = location
                
                let geocoder = CLGeocoder()
                geocoder.reverseGeocodeLocation(location) { placemarks, error in
                    if let placemark = placemarks?.first {
                        let address = [
                            placemark.administrativeArea,
                            placemark.locality,
                            placemark.subLocality,
                            placemark.name
                        ].compactMap { $0 }.joined()
                        
                        DispatchQueue.main.async {
                            self.address = address
                            print("📍 地址：\(address)")
                        }
                    } else {
                        print("❌ 無法取得地址：\(error?.localizedDescription ?? "未知錯誤")")
                    }
                }
            }
        }
    }
    
    // MARK: - Update Selected Image
    func updateSelectedImage(_ image: UIImage?) {
        self.selectedImage = image
    }
    
    func resetResultState() {
        earnedStamp = nil
        earnedPointMessage = nil
        showResultDialog = false
    }
    
    // MARK: - Update Stamps
    func updateStamps(stamps: Int, castleName: String) {
        guard let user else { return }
        Task {
            try await UserManager.shared.updateStamps(userId: user.userId)
            alertMsg = "恭喜獲得\(castleName)印章"
            showResultDialog = true
            Analytics.logEvent("stamp_earned", parameters: [
                "stamp_name": castleName,
                "user_id": user.userId
            ])
        }
    }
    
    // MARK: - Update Points
    func updatePoints(points: Int) {
        guard let user else { return }
        Task {
            try await UserManager.shared.updatePoints(userId: user.userId, point: points)
            earnedPointMessage = "你獲得了 \(points) 點數 🎉"
            showResultDialog = true
        }
    }
    
    // MARK: - Write Post
    func writePost(postTitle: String, location: String, author: String, type: String, comment: String, tags: [String]) async -> Int {
        guard let user else {
            print("no user")
            return 3
        }
        
        var res = 3
        guard let selectedImage = self.selectedImage else {
            print("no image selected")
            return res
        }
        guard let photoData = selectedImage.jpegData(compressionQuality: 0.8) else {
            print("圖片壓縮失敗")
            return res
        }
        
        do {
            let (path, name) = try await StorageManager.shared.saveImage(data: photoData, userId: user.userId)
            print("📸 儲存成功！path: \(path), name: \(name)")
            
            let url = try await StorageManager.shared.getUrlForImage(path: path)
            
            withAnimation { self.isWriting = true }
            
            let coordinates = Coordinates(
                latitude: photoLocation?.coordinate.latitude ?? 0,
                longitude: photoLocation?.coordinate.longitude ?? 0
            )
            
            let post = try Post(
                title: postTitle,
                location: location,
                coordinates: coordinates,
                author: user.userNickname ?? "",
                userId: user.userId,
                type: type,
                date: Date(),
                visitedDate: self.photoDate,
                comment: comment,
                address: self.address,
                tag: tags,
                postPhotoPath: path,
                postPhotoPathUrl: url.absoluteString
            )
            
            var matchedCastleName: String? = nil
            do {
                (res, matchedCastleName) = try await PostManager.shared.getDigitalRewards(for: post)
                earnedStamp = matchedCastleName
            } catch {
                print("🎯 getDigitalRewards 發生錯誤：\(error)")
            }
            
            try await PostManager.shared.createNewPost(post: post)
            
            Analytics.logEvent("post_uploaded", parameters: [
                "post_type": type,
                "location": location,
                "tag_count": tags.count,
                "earned_stamp": earnedStamp ?? "none"
            ])
            
            if self.posts != nil {
                self.posts?.insert(post, at: 0)
            } else {
                self.posts = [post]
            }
            
        } catch {
            print("Failed to create post: \(error)")
            alertMsg = "貼文建立失敗，請稍後再試"
            showAlert = true
        }
        
        self.selectedImage = nil
        withAnimation {
            isWriting = false
            createPost = false
        }
        
        return res
    }
}
