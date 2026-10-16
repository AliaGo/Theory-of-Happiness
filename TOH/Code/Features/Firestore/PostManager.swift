
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

struct Comment: Identifiable, Codable, Hashable {
    var id: String  // 對應 Firestore documentID
    var userId: String
    var userNickname: String? // 有暱稱就顯示暱稱
    var text: String
    var timestamp: Timestamp
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
    var comment: String? //貼文者自己的評論
    var commentCount: Int = 0
    var address: String?
    var tag: [String]?
    var likes: [String]? // 存userId
    var likeCount: Int = 0
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
        case commentCount = "commentCount"
        case address = "address"
        case tag = "tag"
        case likes = "likes"
        case likeCount = "likeCount"
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
        commentCount: Int = 0,
        address: String? = nil,
        tag: [String]? = nil,
        likes: [String]? = nil,
        likeCount: Int = 0,
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
        self.commentCount = commentCount
        self.address = address
        self.tag = tag
        self.likes = likes
        self.likeCount = likeCount
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
        self.commentCount = try container.decode(Int.self, forKey: .commentCount)
        self.address = try container.decodeIfPresent(String.self, forKey: .address)
        self.tag = try container.decodeIfPresent([String].self, forKey: .tag)
        self.likes = try container.decode([String].self, forKey: .likes)
        self.likeCount = try container.decode(Int.self, forKey: .likeCount)
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
        try container.encode(self.commentCount, forKey: .commentCount)
        try container.encode(self.address, forKey: .address)
        try container.encode(self.tag, forKey: .tag)
        try container.encode(self.likes, forKey: .likes)
        try container.encode(self.likeCount, forKey: .likeCount)
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
    
    private var listener: ListenerRegistration?
    
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
    // 排序最新到最舊貼文
    func getAllposts() async throws -> [Post] {

        let snapshot = try await postCollection
            .order(by: Post.CodingKeys.date.rawValue,
                   descending: true)
            .getDocuments()

        var posts: [Post] = []

        for document in snapshot.documents {
            do {
                let post = try document.data(as: Post.self)
                posts.append(post)

            } catch {
                print("❌ Decode failed for document: \(document.documentID)")
                print(error)
                print(document.data())
            }
        }

        print("✅ Posts fetched count: \(posts.count)")

        return posts
    }
    
    // 即時同步貼文內容與用戶互動
    
    func observePosts(completion: @escaping ([Post]) -> Void) {

        listener?.remove()

        listener = postCollection
            .order(by: "date", descending: true)
            .addSnapshotListener { snapshot, error in

                if let error = error {
                    print("❌ Firestore error:", error)
                    return
                }

                guard let documents = snapshot?.documents else {
                    print("⚠️ snapshot is nil")
                    completion([])
                    return
                }

                print("🔥 docs:", documents.count)

                var posts: [Post] = []

                for doc in documents {
                    do {
                        let post = try doc.data(as: Post.self)
                        posts.append(post)
                    } catch {
                        print("❌ decode failed:", doc.documentID)
                        print(error)
                        print(doc.data())
                    }
                }

                completion(posts)
            }
    }
    
    func stopObservingPosts() {
        listener?.remove()
        listener = nil
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
    
    func getDigitalRewards(for post: Post) async throws -> (Int, String?) {
        switch post.type {
        case "castle":
            return try await getCastleDigitalStamp(post: post)
        case "ramen":
            return (try await getRamenPoints(post: post),nil)
        default:
            return (3, nil) // 都沒有
        }
    }
    
    // 獲取城堡印章並將城堡資料新增到使用者的 collectedStamps
    private func getCastleDigitalStamp(post: Post) async throws -> (Int, String?) {
        let snapshot = try await castlesCollection.getDocuments()
        
        for document in snapshot.documents {
            if let castleCoordinates = document["coordinates"] as? [String: Double],
               let latitude = castleCoordinates["latitude"],
               let longitude = castleCoordinates["longitude"] {
                let castleLocation = CLLocation(latitude: latitude, longitude: longitude)
                // 如果照片位置與城堡位置相符
                if post.photoLocation.distance(from: castleLocation) < 1000 { // 比對 1000 米內視為一致
                    let castleId = document["id"] // 儲存匹配的城堡 ID
                    let castleName = document["name"] as? String ?? "Unknown Castle" // 儲存城堡名稱
                    
                    // 儲存匹配到的城堡印章資料到 user 的 collectedStamps 集合
                    // 檢查是否已經收集過這個印章
                    let alreadyCollected = try await hasCollectedStamp(userId: post.userId, castleId: castleId as! Int)
                    guard !alreadyCollected else {
                        print("⚠️ 使用者已擁有印章：\(castleId)")
                        return (0, castleName) // 表示已擁有，不再新增
                    }

                    // 如果還沒收集過，才新增
                    try await saveCastleStampToUser(userId: post.userId, castleId: castleId as! Int, castleName: castleName)
                    print("✅ 成功新增印章：\(castleId)")
                    return (1, castleName)  // 1 表示成功新增印章
                }
            }
        }
        return (0, nil) // 未找到匹配的城堡
    }
    
    // 檢查是否已經收集過此印章
    private func hasCollectedStamp(userId: String, castleId: Int) async throws -> Bool {
        let db = Firestore.firestore()
        let snapshot = try await db
            .collection("users")
            .document(userId)
            .collection("collected_stamps")
            .whereField(UserCollectedStamps.CodingKeys.castleId.rawValue, isEqualTo: castleId)
            .limit(to: 1)
            .getDocuments()

        return !snapshot.documents.isEmpty
    }

    
    // 儲存城堡印章到 User 的 collectedStamps 集合
    private func saveCastleStampToUser(userId: String, castleId: Int, castleName: String) async throws {
        let db = Firestore.firestore()
            
        let document = db
            .collection("users")
            .document(userId)
            .collection("collected_stamps")
            .document()
        let documentId = document.documentID

        let data:[String: Any] = [
            UserCollectedStamps.CodingKeys.id.rawValue: documentId,
            UserCollectedStamps.CodingKeys.castleId.rawValue: castleId,
            UserCollectedStamps.CodingKeys.castleName.rawValue: castleName,
            UserCollectedStamps.CodingKeys.collectedDate.rawValue: Timestamp()
            
        ]
        
        try await document.setData(data, merge: false)
    }
    
    // 獲取拉麵點數
    private func getRamenPoints(post: Post) async throws -> Int {
        // 拉麵的邏輯可以放這裡，回傳點數
        return 2
    }
    
    func createNewPost(post: Post) async throws {
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
            Post.CodingKeys.likes.rawValue: post.likes,
            Post.CodingKeys.likeCount.rawValue: post.likeCount,
            Post.CodingKeys.tag.rawValue: post.tag,
            Post.CodingKeys.commentCount.rawValue: post.commentCount,
            Post.CodingKeys.postPhotoPath.rawValue: post.postPhotoPath,
            Post.CodingKeys.postPhotoPathUrl.rawValue: post.postPhotoPathUrl
        ]
        print("正要建立")
        
        try await document.setData(postData, merge: false)
        // 方便建立貼文之後跳轉到貼文頁面檢視或是其他用途
        
        //建立貼文的時候增加photo資訊
        var postWithId = post
            postWithId.id = documentId
            try await PhotoManager.shared.addPhoto(userId: post.userId, post: postWithId)
    }
    
    func savePostImagePath(postId: String, path: String?, url: String?) async throws {
        let data: [String: Any] = [
            Post.CodingKeys.postPhotoPath.rawValue: path, //用codingkey確保資料欄位字串無誤
            Post.CodingKeys.postPhotoPathUrl.rawValue: url,
        ]
        
        try await postDocument(postId: postId).updateData(data)
    }
    
    func getPostCount(userId: String, type: String) async throws -> Int {
        let snapshot = try await Firestore.firestore()
            .collection("posts")
            .whereField("userId", isEqualTo: userId)
            .whereField("type", isEqualTo: type)
            .getDocuments()

        return snapshot.documents.count
    }
    
    // 按讚功能
    func toggleLike(postId: String, userId: String, completion: ((Error?) -> Void)? = nil) {

        let postRef = postDocument(postId: postId)

        Firestore.firestore().runTransaction({ transaction, errorPointer in

            let postDoc: DocumentSnapshot

            do {
                postDoc = try transaction.getDocument(postRef)
            } catch {
                print("❌ Error fetching post:", error)
                return nil
            }

            var likes = postDoc.data()?["likes"] as? [String] ?? []
            var likeCount = postDoc.data()?["likeCount"] as? Int ?? 0

            let isLiked = likes.contains(userId)

            if isLiked {
                likes.removeAll { $0 == userId }
                likeCount = max(likeCount - 1, 0)
            } else {
                likes.append(userId)
                likeCount += 1
            }

            transaction.updateData([
                "likes": likes,
                "likeCount": likeCount
            ], forDocument: postRef)

            return nil

        }, completion: { _, error in
            completion?(error)
        })
    }
    
    // 留言功能
    func addComment(postId: String, userId: String, userNickname: String?, text: String) {
        let commentRef = postDocument(postId: postId).collection("comments").document()
        
        let commentData: [String: Any] = [
            "id": commentRef.documentID,   // 自動生成的 documentID
            "userId": userId,
            "userNickname": userNickname ?? "匿名",
            "text": text,
            "timestamp": Timestamp()
        ]
        let postDoc = postDocument(postId: postId)
        
        commentRef.setData(commentData) { error in
            if let error = error {
                print(error)
            } else {

                postDoc.updateData([
                    "commentCount": FieldValue.increment(Int64(1))
                ])

            }
        }
    }

    func reportComment(postId: String, comment: Comment, reporterId: String) async throws {
        guard !reporterId.isEmpty else {
            throw URLError(.userAuthenticationRequired)
        }

        let reportRef = Firestore.firestore().collection("reports").document()
        try await reportRef.setData([
            "type": "comment",
            "postId": postId,
            "commentId": comment.id,
            "reportedUserId": comment.userId,
            "reporterId": reporterId,
            "commentText": comment.text,
            "createdAt": Timestamp(),
            "status": "pending"
        ])
    }
    
    func fetchComments(postId: String, completion: @escaping ([Comment]) -> Void) {
        postDocument(postId: postId)
            .collection("comments")
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else { return }
                let comments = documents.compactMap { doc -> Comment? in
                    let data = doc.data()
                    guard let userId = data["userId"] as? String,
                          let nickname = data["userNickname"] as? String,
                          let text = data["text"] as? String else { return nil }
                    return Comment(id: doc.documentID, userId: userId, userNickname: nickname, text: text, timestamp: Timestamp())
                }
                completion(comments)
            }
    }
}
