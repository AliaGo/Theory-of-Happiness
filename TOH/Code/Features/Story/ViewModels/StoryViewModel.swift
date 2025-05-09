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


@MainActor
final class StoryViewModel: ObservableObject {
    
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
    
    // 用來控制是否顯示獲得獎勵對話框
    @Published var showResultDialog: Bool = false
    // 獲得的印章資料（若是 castle 類型）
    @Published var earnedStamp: String? = nil
    // 拉麵類型貼文則顯示點數和文字訊息
    @Published var earnedPointMessage: String? = nil
    
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
    
    func loadCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
    }
    
    func deletePost(post: Post) {
        
        guard let _ = posts else {return}
        
        let index = posts?.firstIndex(where: { currentPost in
            return currentPost.id == post.id
        }) ?? 0
        
        //withAnimation{posts?.remove(at: index)}
    }
    
    func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long // 设置日期样式，可以选择.short, .medium, .long, .full
        dateFormatter.timeStyle = .none // 不显示时间，如果需要显示时间可以设置为 .short 或 .medium

        return dateFormatter.string(from: date) // 返回格式化后的日期字符串
    }
    
    // 圖片先暫存在記憶體還沒有正式上傳到storage
    func selectImage(item: PhotosPickerItem) {
        Task {
            guard let data = try? await item.loadTransferable(type: Data.self),
                  let image = UIImage(data: data) else {
                print("❌ 選圖失敗")
                return
            }
            
            if let imageSource = CGImageSourceCreateWithData(data as CFData, nil) {
                
                // ➤ 取得 metadata
                if let metadata = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as? [CFString: Any] {
                    
                    // ➤ 取得日期
                    if let tiffDict = metadata[kCGImagePropertyTIFFDictionary] as? [CFString: Any],
                       let dateString = tiffDict[kCGImagePropertyTIFFDateTime] as? String {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy:MM:dd HH:mm:ss"
                        self.photoDate = formatter.date(from: dateString)
                    }
                    
                    // ➤ 取得 GPS 地點
                    if let gpsDict = metadata[kCGImagePropertyGPSDictionary] as? [CFString: Any],
                       let lat = gpsDict[kCGImagePropertyGPSLatitude] as? Double,
                       let latRef = gpsDict[kCGImagePropertyGPSLatitudeRef] as? String,
                       let lon = gpsDict[kCGImagePropertyGPSLongitude] as? Double,
                       let lonRef = gpsDict[kCGImagePropertyGPSLongitudeRef] as? String {
                        
                        let latitude = (latRef == "S") ? -lat : lat
                        let longitude = (lonRef == "W") ? -lon : lon
                        let location = CLLocation(latitude: latitude, longitude: longitude)
                            self.photoLocation = location

                            // ➤ 反向地理編碼
                            let geocoder = CLGeocoder()
                            geocoder.reverseGeocodeLocation(location) { placemarks, error in
                                if let placemark = placemarks?.first {
                                    // ➤ 組合地址（可依需求微調）
                                    let address = [
                                        placemark.administrativeArea, // 都道府県
                                        placemark.locality,           // 市区町村
                                        placemark.subLocality,        // 區域
                                        placemark.name                // 詳細地址
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

            print("✅ 圖片已轉換為 UIImage")

            await MainActor.run {
                self.selectedImage = image
                print("✅ selectedImage 已設定")
            }
        }
    }

    // 確保在主程式更新 selectedImage，防止 UI 閃退
    func updateSelectedImage(_ image: UIImage?) {
        self.selectedImage = image
    }
    
    func resetResultState() {
        earnedStamp = nil
        earnedPointMessage = nil
        showResultDialog = false
    }
    
    //更新資料庫使用者的印章數，並建立印章資訊
    func updateStamps(stamps: Int, castleName: String) {
        guard let user else { return }
        
        Task {
            try await UserManager.shared.updateStamps(userId: user.userId)
            
            alertMsg = "恭喜獲得\(castleName)印章"
            // 更新印章邏輯
            showResultDialog = true
            
            return
        }
        
    }
    
    func updatePoints(points: Int) {
        guard let user else { return }
        
        Task {
            try await UserManager.shared.updatePoints(userId: user.userId, point: points)
            
            earnedPointMessage = "你獲得了 \(points) 點數 🎉"
            showResultDialog = true
        }
    }
    
    func writePost(postTitle: String, location: String, author: String, type: String, comment: String, tags: [String]) async -> Int{
        guard let user else {
            print("no user")
            return 3}

        var res = 3
        
        guard let selectedImage = self.selectedImage else {
            print("no image selected")
            return res} // 確保有圖片
        
        
        guard let photoData = self.selectedImage?.jpegData(compressionQuality: 0.8) else {
            print("圖片壓縮失敗")
            return res}
        
        
        do {
            let (path, name) = try await StorageManager.shared.saveImage(data: photoData, userId: user.userId)
            
            print("📸 儲存成功！path: \(path), name: \(name)")
            
            let url = try await StorageManager.shared.getUrlForImage(path: path)
            
            // loading animation
            withAnimation{
                self.isWriting = true
            }
            
            let coordinates = Coordinates(latitude: photoLocation?.coordinate.latitude ?? 0,
                longitude: photoLocation?.coordinate.longitude ?? 0)
            print("selectedTags: \(tags)")
            
            let post = try Post(title: postTitle, location: location, coordinates: coordinates, author: user.userNickname ?? "", userId: user.userId, type: type, date: Date(), visitedDate: self.photoDate, comment: comment, address: self.address, tag: tags, postPhotoPath: path, postPhotoPathUrl: url.absoluteString)
            
            // result有三種結果：1城堡2拉麵3都沒有
            let (result, matchedCastleName) = try await PostManager.shared.getDigitalRewards(for: post)
            
            earnedStamp = matchedCastleName
            res = result
            
            try await PostManager.shared.createNewPost(post: post)
        } catch {
            print("Failed to create post: \(error)")
        }
        
        self.selectedImage = nil
        
        // loading animation
        withAnimation{
            //adding to post
            //self.posts?.append(post)
            isWriting = false
            //closing post view
            createPost = false
        }
        
        return res
    }
    
    
    /*
    func writePost(postTitle: String, location: String, author: String, type: String) {
        Task {
                guard let user else { return }
                guard let selectedImage else { return } // 確保有圖片
            
                guard let photoData = selectedImage.jpegData(compressionQuality: 0.8) else { return }
                let (path, name) = try await StorageManager.shared.saveImage(data: photoData, userId: user.userId)
                
                let url = try await StorageManager.shared.getUrlForImage(path: path)
                
                self.alertMsg = "cryyyyyyy"
                print(alertMsg)
                
                // loading animation
                withAnimation{
                    self.isWriting = true
                }
                
                
                let postRef = Firestore.firestore().collection("posts").document() // 自動生成 ID
                let postId = postRef.documentID
                
                print("Generated postID: \(postId)")
                
                // storing to firebase db
                let post: [String:Any] = [
                    Post.CodingKeys.id.rawValue: postId,
                    Post.CodingKeys.title.rawValue: postTitle,
                    Post.CodingKeys.location.rawValue: location,
                    Post.CodingKeys.author.rawValue: author,
                    Post.CodingKeys.type.rawValue: type,
                    Post.CodingKeys.postPhotoPath.rawValue: path,
                    Post.CodingKeys.postPhotoPathUrl.rawValue: url.absoluteString
                ]
                
                // Saving post to Firestore
                try await postRef.setData(post, merge: false)
                print("Post created successfully")
                
                //try await PostManager.shared.createNewPost(post: post)
                
                //print("Post created successfully")
                
                // loading animation
                withAnimation{
                    //adding to post
                    //self.posts?.append(post)
                    isWriting = false
                    //closing post view
                    createPost = false
                }
            
            
        }
    }
    */
}
