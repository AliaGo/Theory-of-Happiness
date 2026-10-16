import Foundation
import FirebaseFirestore

// Firestore 照片資料模型
struct Photo: Identifiable, Codable {
    @DocumentID var id: String?
    let postId: String
    let imagePath: String
    let description: String?
    let type: String
    let title: String
    let location: String?
    
    /// 如果 visitedDate 沒有，就 fallback 用建立貼文時間 createdAt
    let visitedDate: Date?
    let createdAt: Date

    var displayDate: Date {
        visitedDate ?? createdAt
    }

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年M月"
        return formatter.string(from: displayDate)
    }
}


final class PhotoManager {
    static let shared = PhotoManager()
    private init() {}

    private let db = Firestore.firestore()

    // 照片類型
    enum PhotoType: String {
        case castle
        case ramen
    }

    

    // MARK: - Reference Helpers

    private func userPhotosRef(userId: String, type: PhotoType) -> CollectionReference {
        db.collection("users").document(userId).collection("photos").document(type.rawValue).collection("items")
    }

    // MARK: - CRUD

    // 新增照片記錄（上傳後 StorageManager 回傳 path 後呼叫）
    func addPhoto(userId: String, post: Post) async throws {
        let type: PhotoType = PhotoType(rawValue: post.type) ?? .castle
        
        let data: [String: Any] = [
            "postId": post.id, // <- 新增
            "imagePath": post.postPhotoPathUrl,
            "description": post.comment ?? "",
            "type": type.rawValue,
            "title": post.title,
            "location": post.location,
            "visitedDate": Timestamp(date: (post.visitedDate ?? post.date) ?? Date()),
            "createdAt": Timestamp(date: Date())
        ]
        
        try await userPhotosRef(userId: userId, type: type)
            .document(post.id)
            .setData(data, merge: false)
    }


    // 抓取特定使用者某類型照片
    func fetchPhotos(userId: String, type: PhotoType) async throws -> [Photo] {
        let snapshot = try await userPhotosRef(userId: userId, type: type)
            .order(by: "visitedDate", descending: true)
            .getDocuments()

        let photos = snapshot.documents.compactMap { try? $0.data(as: Photo.self) }
        return try await removingLegacyDuplicates(from: photos)
    }

    // 舊版曾將同一張照片索引寫入兩次；保留能連回有效貼文的紀錄。
    private func removingLegacyDuplicates(from photos: [Photo]) async throws -> [Photo] {
        let groupedPhotos = Dictionary(grouping: photos, by: \.imagePath)
        var visiblePhotos: [Photo] = []

        for photo in photos {
            guard let matches = groupedPhotos[photo.imagePath], matches.count > 1 else {
                visiblePhotos.append(photo)
                continue
            }

            guard photo.id == matches.first?.id else { continue }

            let validPhoto = try await matches.asyncFirst { photo in
                try await self.db.collection("posts").document(photo.postId).getDocument().exists
            }
            visiblePhotos.append(validPhoto ?? photo)
        }

        return visiblePhotos
    }

    // 刪除照片紀錄（不含 Storage 圖片刪除）
    func deletePhoto(userId: String, type: PhotoType, photoId: String) async throws {
        try await userPhotosRef(userId: userId, type: type).document(photoId).delete()
    }
}

private extension Array {
    func asyncFirst(
        where predicate: (Element) async throws -> Bool
    ) async rethrows -> Element? {
        for element in self {
            if try await predicate(element) {
                return element
            }
        }
        return nil
    }
}
