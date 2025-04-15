//
//  PostManager.swift
//  TOH
//
//  Created by Alia on 2025/3/14.
//

import Foundation
import FirebaseFirestore
import SwiftUI
import CoreLocation

struct Coordinates: Codable, Hashable {
    var latitude: Double
    var longitude: Double
}

struct Post: Hashable, Identifiable, Codable {
    var id: String
    var title: String
    var location: String
    var coordinates: Coordinates?
    var author: String
    var userId: String
    var type: String
    //var postContent: [PostContent]
    var date: Date? // 上傳時間
    var visitedDate: Date? // 拜訪時間
    var comment: String?
    var postPhotoPath: String
    var postPhotoPathUrl: String
    
    // 根據座標算出 CLLocation
    var photoLocation: CLLocation {
        CLLocation(latitude: coordinates?.latitude ?? 0, longitude: coordinates?.longitude ?? 0)
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case location = "location"
        case coordinates = "coordinates"
        case author = "author"
        case userId = "userId"
        case type = "type"
        //case postContent = "postContent"
        case date = "date"
        case visitedDate = "visitedDate"
        case comment = "comment"
        case postPhotoPath = "postPhotoPath"
        case postPhotoPathUrl = "postPhotoPathUrl"
    }
    
    init(
        id: String = UUID().uuidString, // 使用默认的UUID作为ID
        title: String,
        location: String,
        coordinates: Coordinates,
        author: String,
        userId: String,
        type: String,
        date: Date? = nil,
        visitedDate: Date? = nil,
        comment: String? = nil,
        postPhotoPath: String,
        postPhotoPathUrl: String
        
    ) {
        self.id = id
        self.title = title
        self.location = location
        self.coordinates = coordinates
        self.author = author
        self.userId = userId
        self.type = type
        self.date = date
        self.visitedDate = visitedDate
        self.comment = comment
        self.postPhotoPath = postPhotoPath
        self.postPhotoPathUrl = postPhotoPathUrl
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.location = try container.decode(String.self, forKey: .location)
        self.coordinates = try container.decodeIfPresent(Coordinates.self, forKey: .coordinates)
        self.author = try container.decode(String.self, forKey: .author)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.type = try container.decode(String.self, forKey: .type)
        //self.postContent = try container.decode([PostContent].self, forKey: .postContent)
        self.date = try container.decodeIfPresent(Date.self, forKey: .date)
        self.visitedDate = try container.decodeIfPresent(Date.self, forKey: .visitedDate)
        self.comment = try container.decodeIfPresent(String.self, forKey: .comment)
        self.postPhotoPath = try container.decode(String.self, forKey: .postPhotoPath)
        self.postPhotoPathUrl = try container.decode(String.self, forKey: .postPhotoPathUrl)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.title, forKey: .title)
        try container.encode(self.location, forKey: .location)
        try container.encode(self.author, forKey: .author)
        try container.encode(self.userId, forKey: .userId)
        try container.encode(self.type, forKey: .type)
        //try container.encode(self.postContent, forKey: .postContent)
        try container.encode(self.date, forKey: .date)
        try container.encode(self.visitedDate, forKey: .visitedDate)
        try container.encode(self.comment, forKey: .comment)
        try container.encode(self.postPhotoPath, forKey: .postPhotoPath)
        try container.encode(self.postPhotoPathUrl, forKey: .postPhotoPathUrl)
    }
}
/*
struct PostContent: Identifiable, Codable {
    var id = UUID().uuidString
    var date: Timestamp
    var contentName: String
    var comment: String?
    var postPhotoPaths: [String]?
    var postPhotoPathUrls: [String]?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case date
        case contentName = "contentName"
        case comment = "comment"
        case postPhotoPaths = "postPhotoPaths"
        case postPhotoPathUrls = "postPhotoPathUrls"
    }
}*/

//enum PostType

final class PostManager {
    
    static let shared = PostManager()
    private init() {}
    // 要比對貼文位置給予印章或點數
    private let castlesCollection = Firestore.firestore().collection("castles")
    private let ramensCollection = Firestore.firestore().collection("ramens")
    
    private let postCollection: CollectionReference = Firestore.firestore().collection("posts")
    
    private func postDocument(postId: String) -> DocumentReference {
        postCollection.document(postId)
    }
    
    func getPost(postId: String) async throws -> Post {
        try await postDocument(postId: postId).getDocument(as: Post.self)
    }
    
    func getAllposts() async throws -> [Post] {
        let posts = try await postCollection.getDocuments(as: Post.self)
        print("Posts fetched: \(posts)")
        return posts
    }
    
    // 把寫進資料庫的符合欄位大小寫
    private let encoder: Firestore.Encoder = {
        let encoder = Firestore.Encoder()
        //encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()
    
    private let decoder: Firestore.Decoder = {
        let decoder = Firestore.Decoder()
        //decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    func getDigitalRewards(for post: Post) async throws -> Int {
        switch post.type {
        case "castle":
            return try await getCastleDigitalStamp(post: post)
        case "ramen":
            return try await getRamenPoints(post: post)
        default:
            return 3 // 都沒有
        }
    }
    
    // 獲取城堡印章並將城堡資料新增到使用者的 collectedStamps
    private func getCastleDigitalStamp(post: Post) async throws -> Int {
        let snapshot = try await castlesCollection.getDocuments()
        
        for document in snapshot.documents {
            if let castleCoordinates = document["coordinates"] as? [String: Double],
               let latitude = castleCoordinates["latitude"],
               let longitude = castleCoordinates["longitude"] {
                let castleLocation = CLLocation(latitude: latitude, longitude: longitude)
                // 如果照片位置與城堡位置相符
                if post.photoLocation.distance(from: castleLocation) < 1000 { // 比對 1000 米內視為一致
                    let castleId = document.documentID // 儲存匹配的城堡 ID
                    let castleName = document["name"] as? String ?? "Unknown Castle" // 儲存城堡名稱
                    
                    // 儲存匹配到的城堡印章資料到 user 的 collectedStamps 集合
                    try await saveCastleStampToUser(userId: post.userId, castleId: castleId, castleName: castleName)
                    return 1 // 給予城堡數位印章
                }
            }
        }
        return 0 // 未找到匹配的城堡
    }
    
    // 儲存城堡印章到 User 的 collectedStamps 集合
    private func saveCastleStampToUser(userId: String, castleId: String, castleName: String) async throws {
        let userRef = Firestore.firestore().collection("users").document(userId)
        
        // 取得使用者資料並更新 collectedStamps
        let userSnapshot = try await userRef.getDocument()
        var collectedStamps = userSnapshot.data()?["collectedStamps"] as? [String: [String: String]] ?? [:]
        
        // 新增城堡印章資料
        collectedStamps[castleId] = [
            "name": castleName,
            "castleId": castleId
        ]
        
        // 更新使用者資料
        try await userRef.updateData([
            "collectedStamps": collectedStamps
        ])
    }
    
    // 獲取拉麵點數
    private func getRamenPoints(post: Post) async throws -> Int {
        // 拉麵的邏輯可以放這裡，回傳點數
        return 2
    }
    
    func createNewPost(post: Post) async throws -> String {
        let document = postCollection.document() //先在資料庫建有autoID的document
        let documentId = document.documentID  // 得到autoID資訊
        
        print("在create了")
        
        let postData: [String:Any] = [
            Post.CodingKeys.id.rawValue: documentId,
            Post.CodingKeys.title.rawValue: post.title,
            Post.CodingKeys.location.rawValue: post.location,
            Post.CodingKeys.author.rawValue: post.author,
            Post.CodingKeys.type.rawValue: post.type,
            Post.CodingKeys.userId.rawValue: post.userId,
            Post.CodingKeys.date.rawValue: post.date,
            Post.CodingKeys.visitedDate.rawValue: post.visitedDate,
            Post.CodingKeys.comment.rawValue: post.comment,
            Post.CodingKeys.postPhotoPath.rawValue: post.postPhotoPath,
            Post.CodingKeys.postPhotoPathUrl.rawValue: post.postPhotoPathUrl
        ]
        print("正要建立")
        
        try await document.setData(postData, merge: false)
        // 方便建立貼文之後跳轉到貼文頁面檢視或是其他用途
        return documentId
    }
    
    func savePostImagePath(postId: String, path: String?, url: String?) async throws {
        let data: [String: Any] = [
            Post.CodingKeys.postPhotoPath.rawValue: path, //用codingkey確保資料欄位字串無誤
            Post.CodingKeys.postPhotoPathUrl.rawValue: url,
        ]
        
        try await postDocument(postId: postId).updateData(data)
    }
}
