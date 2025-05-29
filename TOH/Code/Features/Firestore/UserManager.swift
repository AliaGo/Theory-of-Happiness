//
//  UserManager.swift
//  TOH
//
//  Created by Alia on 2025/1/29.
//

import Foundation
import FirebaseFirestore
import SwiftUI

struct DBUser: Codable {
    let userId: String
    let userNickname: String?
    let email: String?
    let photoUrl: String?
    let dateCreated: Date?
    let isPremium: Bool?
    let profileImagePath: String?
    let profileImagePathUrl: String?
    let points: Int?
    let stamps: Int?
    let ranking: Int?
    
    init(auth: AuthDataResultModel) {
        self.userId = auth.uid
        self.userNickname = auth.displayName
        self.email = auth.email
        self.photoUrl = auth.photoUrl
        self.dateCreated = Date()
        self.isPremium = false
        self.profileImagePath = nil
        self.profileImagePathUrl = nil
        self.points = nil
        self.stamps = nil
        self.ranking = nil
    }
    
    init(
        userId: String,
        userNickname: String? = nil,
        email: String? = nil,
        photoUrl: String? = nil,
        dateCreated: Date? = nil,
        isPremium: Bool? = nil,
        profileImagePath: String? = nil,
        profileImagePathUrl: String? = nil,
        points: Int? = nil,
        stamps: Int? = nil,
        ranking: Int? = nil
    ) {
        self.userId = userId
        self.userNickname = userNickname
        self.email = email
        self.photoUrl = photoUrl
        self.dateCreated = dateCreated
        self.isPremium = isPremium
        self.profileImagePath = profileImagePath
        self.profileImagePathUrl = profileImagePathUrl
        self.points = points
        self.stamps = stamps
        self.ranking = ranking
    }
    /*
    func togglePremiumStatus() -> DBUser {
        let currentValue = isPremium ?? false
        return DBUser(
            userId: userId,
            email: email,
            photoUrl: photoUrl,
            dateCreated: dateCreated,
            isPremium: !currentValue
        )
    }
    */
    /*
    // mutate the struct from within the struct itself
    mutating func togglePremiumStatus() {
        let currentValue = isPremium ?? false
        isPremium = !currentValue
    }
     */
    // CodingKey可以確保協作者不用去猜資料欄位的名稱
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case userNickname = "userNickname"
        case email = "email"
        case photoUrl = "photo_url"
        case dateCreated = "date_created"
        case isPremium = "user_isPremium"
        case profileImagePath = "profile_image_path"
        case profileImagePathUrl = "profile_image_path_url"
        case points = "points"
        case stamps = "stamps"
        case ranking = "ranking"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.userNickname = try container.decodeIfPresent(String.self, forKey: .userNickname)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.photoUrl = try container.decodeIfPresent(String.self, forKey: .photoUrl)
        self.dateCreated = try container.decodeIfPresent(Date.self, forKey: .dateCreated)
        self.isPremium = try container.decodeIfPresent(Bool.self, forKey: .isPremium)
        self.profileImagePath = try container.decodeIfPresent(String.self, forKey: .profileImagePath)
        self.profileImagePathUrl = try container.decodeIfPresent(String.self, forKey: .profileImagePathUrl)
        self.points = try container.decodeIfPresent(Int.self, forKey: .points)
        self.stamps = try container.decodeIfPresent(Int.self, forKey: .stamps)
        self.ranking = try container.decodeIfPresent(Int.self, forKey: .ranking)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userId, forKey: .userId)
        try container.encodeIfPresent(self.userNickname, forKey: .userNickname)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.photoUrl, forKey: .photoUrl)
        try container.encodeIfPresent(self.dateCreated, forKey: .dateCreated)
        try container.encodeIfPresent(self.isPremium, forKey: .isPremium)
        try container.encodeIfPresent(self.profileImagePath, forKey: .profileImagePath)
        try container.encodeIfPresent(self.profileImagePathUrl, forKey: .profileImagePathUrl)
        try container.encodeIfPresent(self.points, forKey: .points)
        try container.encodeIfPresent(self.stamps, forKey: .stamps)
        try container.encodeIfPresent(self.ranking, forKey: .ranking)
    }
    
}


final class UserManager {
    
    static let shared = UserManager()
    private init() {}
    
    private let userCollection: CollectionReference = Firestore.firestore().collection("users")
    
    private func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
    
    // Collected Castle Stamps
    private func userCollectedStampsCollection(userId: String) -> CollectionReference {
        userDocument(userId: userId).collection("collected_stamps")
    }
    
    private func userCollectedStampsDocument(userId: String, castleId: String) -> DocumentReference {
        userCollectedStampsCollection(userId: userId).document(castleId)
    }
    
    // Fav Castles
    private func userFavoriteCastleCollection(userId: String) -> CollectionReference {
        userDocument(userId: userId).collection("favorite_castles")
    }
    
    private func userFavoriteCastleDocument(userId: String, favoriteCastleId: String) -> DocumentReference {
        userFavoriteCastleCollection(userId: userId).document(favoriteCastleId)
    }
    
    // Fav Ramens
    private func userFavoriteRamenCollection(userId: String) -> CollectionReference {
        userDocument(userId: userId).collection("favorite_ramens")
    }
    
    private func userFavoriteRamenDocument(userId: String, favoriteRamenId: String) -> DocumentReference {
        userFavoriteRamenCollection(userId: userId).document(favoriteRamenId)
    }
    
    // Fav TWRamens
    private func userFavoriteTWRamenCollection(userId: String) -> CollectionReference {
        userDocument(userId: userId).collection("favorite_tw_ramens")
    }
    
    private func userFavoriteTWRamenDocument(userId: String, favoriteTWRamenId: String) -> DocumentReference {
        userFavoriteTWRamenCollection(userId: userId).document(favoriteTWRamenId)
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
    
    // for signInAnonymous method
    func createNewUser(user: DBUser) async throws {
        try userDocument(userId: user.userId).setData(from: user, merge: false) // 不確定要不要await
    }
 
    // 確認資料庫是否已存在使用者名字
    func checkIfUserExist(user: AuthDataResultModel) async throws {
        let docRef = userCollection.document(user.uid)
        let snapshot = try await docRef.getDocument()
        
        if !snapshot.exists {
            let newUser = DBUser(auth: user)
            
            try docRef.setData(from: newUser)
            print("🆕 使用者資料已建立")
        } else {
            print("✅ 使用者已存在 Firestore")
        }
    }
    
    /* same as the func above
    func createNewUser(auth: AuthDataResultModel) async throws {
        var userData: [String:Any] = [
            "user_id": auth.uid,
            "data_created": Timestamp(),
        ]
        if let email = auth.email {
            userData["email"] = email
        }
        if let photoUrl = auth.photoUrl {
            userData["photoUrl"] = photoUrl
        }
        
        try await userDocument(userId: auth.uid).setData(userData, merge: false)
    }
    */
    
    func getUser(userId: String) async throws -> DBUser {
        try await userDocument(userId: userId).getDocument(as: DBUser.self)
    }
    
    /*
    func getUser(userId: String) async throws -> DBUser {
        let snapshot = try await Firestore.firestore().collection("user").document(userId).getDocument()
        
        guard let data = snapshot.data(), let userId = data["user_id"] as? String  else {
            throw URLError(.badServerResponse)
        }
        
        let email = data["email"] as? String
        let photoUrl = data["photo_url"] as? String
        let dateCreated = data["data_created"] as? Date
        
        return DBUser(userId: userId, email: email, photoUrl: photoUrl, dateCreated: dateCreated)
    }
     */
    
    /*
    func updateUserPremiumStatus(user:DBUser) async throws {
        try userDocument(userId: user.userId).setData(from: user, merge: true, encoder: encoder)
    }
     */
    
    // 只讀取並更新某一欄位，不會有整個複寫的風險（例如上面的func)
    func updateUserPremiumStatus(userId: String, isPremium: Bool) async throws {
        let data: [String: Any] = [
            DBUser.CodingKeys.isPremium.rawValue: isPremium //用codingkey確保資料欄位字串無誤
        ]
        
        try await userDocument(userId: userId).updateData(data)
    }
    
    func updateUserNickname(userId: String, userNickname: String) async throws {
        let data: [String: Any] = [
            DBUser.CodingKeys.userNickname.rawValue: userNickname
        ]
        
        try await userDocument(userId: userId).updateData(data)
    }
    
    // 上傳照片獲得城堡印章後給予點數3點
    func updateStamps(userId: String) async throws {
        
        let data: [String: Any] = [
            DBUser.CodingKeys.points.rawValue: FieldValue.increment(Int64(3)),
            DBUser.CodingKeys.stamps.rawValue: FieldValue.increment(Int64(1))
        ]
        
        try await userDocument(userId: userId).updateData(data)
    }
    
    // 上傳拉麵照片後根據是否為百名店給予點數
    func updatePoints(userId: String, point: Int) async throws {
        
        let data: [String: Any] = [
            DBUser.CodingKeys.points.rawValue: FieldValue.increment(Int64(point))
        ]
        
        try await userDocument(userId: userId).updateData(data)
    }
    
    func updateUserProfileImagePath(userId: String, path: String?, url: String?) async throws {
        let data: [String: Any] = [
            DBUser.CodingKeys.profileImagePath.rawValue: path, //用codingkey確保資料欄位字串無誤
            DBUser.CodingKeys.profileImagePathUrl.rawValue: url,
        ]
        
        try await userDocument(userId: userId).updateData(data)
    }
    
    // 取得所有已收集城堡印章的城堡名，回傳陣列
    func getAllUserCollectedStamps(userId: String) async throws -> [UserCollectedStamps] {
        try await userCollectedStampsCollection(userId: userId).getDocuments(as: UserCollectedStamps.self)
    }
    
    //Fav Castles func
    func checkUserFavoriteCastle(userId: String, castleId: Int) async throws -> Bool {
        let favoriteCastlesDocument = try await getAllUserFavoriteCastles(userId: userId)
        var isIncluded: Bool = false
        for document in favoriteCastlesDocument {
            if document.castleId == castleId {
                isIncluded = true
            }
        }
        
        return isIncluded
    }
    
    func addUserFavoriteCastle(userId: String, castleId: Int) async throws {
        let isIncluded = try await checkUserFavoriteCastle(userId: userId, castleId: castleId)
        // 現有最愛清單沒有此城堡才可以新增
        if isIncluded == false {
            let document = userFavoriteCastleCollection(userId: userId).document() //先在資料庫建有autoID的document
            let documentId = document.documentID  // 得到autoID資訊
            
            // 再傳id資料進去
            let data: [String:Any] = [
                UserFavoriteCastle.CodingKeys.id.rawValue: documentId,
                UserFavoriteCastle.CodingKeys.castleId.rawValue: castleId,
                UserFavoriteCastle.CodingKeys.dateCreated.rawValue: Timestamp()
            ]
            
            try await document.setData(data, merge: false)
        } else {
            print(isIncluded)
        }
    }
    
    func removeFavoriteCastle(userId: String, favoriteCastleId: String) async throws {
        try await userFavoriteCastleDocument(userId: userId, favoriteCastleId: favoriteCastleId).delete()
    }
    
    func getAllUserFavoriteCastles(userId: String) async throws -> [UserFavoriteCastle] {
        try await userFavoriteCastleCollection(userId: userId).getDocuments(as: UserFavoriteCastle.self)
    }
    
    //Fav Ramen func
    func checkUserFavoriteRamen(userId: String, ramenId: Int) async throws -> Bool {
        let favoriteRamensDocument = try await getAllUserFavoriteRamens(userId: userId)
        var isIncluded: Bool = false
        for document in favoriteRamensDocument {
            if document.ramenId == ramenId {
                isIncluded = true
            }
        }
        
        return isIncluded
    }
    
    func addUserFavoriteRamen(userId: String, ramenId: Int) async throws {
        let isIncluded = try await checkUserFavoriteRamen(userId: userId, ramenId: ramenId)
        // 現有最愛清單沒有此拉麵才可以新增
        if isIncluded == false {
            let document = userFavoriteRamenCollection(userId: userId).document() //先在資料庫建有autoID的document
            let documentId = document.documentID  // 得到autoID資訊
            
            // 再傳id資料進去
            let data: [String:Any] = [
                UserFavoriteRamen.CodingKeys.id.rawValue: documentId,
                UserFavoriteRamen.CodingKeys.ramenId.rawValue: ramenId,
                UserFavoriteRamen.CodingKeys.dateCreated.rawValue: Timestamp()
            ]
            
            try await document.setData(data, merge: false)
        }
        
    }
    
    func removeFavoriteRamen(userId: String, favoriteRamenId: String) async throws {
        try await userFavoriteRamenDocument(userId: userId, favoriteRamenId: favoriteRamenId).delete()
    }
    
    func getAllUserFavoriteRamens(userId: String) async throws -> [UserFavoriteRamen] {
        try await userFavoriteRamenCollection(userId: userId).getDocuments(as: UserFavoriteRamen.self)
    }
    
    //Fav TWRamen func
    func checkUserFavoriteTWRamen(userId: String, ramenId: String) async throws -> Bool {
        let favoriteTWRamensDocument = try await getAllUserFavoriteTWRamens(userId: userId)
        var isIncluded: Bool = false
        for document in favoriteTWRamensDocument {
            if document.ramenId == ramenId {
                isIncluded = true
            }
        }
        
        return isIncluded
    }
    
    func addUserFavoriteTWRamen(userId: String, ramenId: String) async throws {
        let isIncluded = try await checkUserFavoriteTWRamen(userId: userId, ramenId: ramenId)
        // 現有最愛清單沒有此拉麵才可以新增
        if isIncluded == false {
            let document = userFavoriteTWRamenCollection(userId: userId).document() //先在資料庫建有autoID的document
            let documentId = document.documentID  // 得到autoID資訊
            
            // 再傳id資料進去
            let data: [String:Any] = [
                UserFavoriteTWRamen.CodingKeys.id.rawValue: documentId,
                UserFavoriteTWRamen.CodingKeys.ramenId.rawValue: ramenId,
                UserFavoriteTWRamen.CodingKeys.dateCreated.rawValue: Timestamp()
            ]
            
            try await document.setData(data, merge: false)
        }
        
    }
    
    func removeFavoriteTWRamen(userId: String, favoriteTWRamenId: String) async throws {
        try await userFavoriteTWRamenDocument(userId: userId, favoriteTWRamenId: favoriteTWRamenId).delete()
    }
    
    func getAllUserFavoriteTWRamens(userId: String) async throws -> [UserFavoriteTWRamen] {
        try await userFavoriteTWRamenCollection(userId: userId).getDocuments(as: UserFavoriteTWRamen.self)
    }
}

struct UserCollectedStamps: Codable {
    let id: String
    let castleId: Int
    let castleName: String
    let collectedDate: Date
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case castleId = "castleId"
        case castleName = "castleName"
        case collectedDate = "collectedDate"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.castleId = try container.decode(Int.self, forKey: .castleId)
        self.castleName = try container.decode(String.self, forKey: .castleName)
        self.collectedDate = try container.decode(Date.self, forKey: .collectedDate)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.castleId, forKey: .castleId)
        try container.encode(self.castleName, forKey: .castleName)
        try container.encode(self.collectedDate, forKey: .collectedDate)
    }
}

struct UserFavoriteCastle: Codable {
    let id: String
    let castleId: Int
    let dateCreated: Date
    
    //分別打encode跟decode就會有下三列出現，快速建立codingkey
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case castleId = "castle_id"
        case dateCreated = "date_created"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.castleId = try container.decode(Int.self, forKey: .castleId)
        self.dateCreated = try container.decode(Date.self, forKey: .dateCreated)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.castleId, forKey: .castleId)
        try container.encode(self.dateCreated, forKey: .dateCreated)
    }
    
    
}

struct UserFavoriteRamen: Codable {
    let id: String
    let ramenId: Int
    let dateCreated: Date
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case ramenId = "ramen_id"
        case dateCreated = "date_created"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.ramenId = try container.decode(Int.self, forKey: .ramenId)
        self.dateCreated = try container.decode(Date.self, forKey: .dateCreated)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.ramenId, forKey: .ramenId)
        try container.encode(self.dateCreated, forKey: .dateCreated)
    }
    
}

struct UserFavoriteTWRamen: Codable {
    let id: String
    let ramenId: String
    let dateCreated: Date
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case ramenId = "ramen_id"
        case dateCreated = "date_created"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.ramenId = try container.decode(String.self, forKey: .ramenId)
        self.dateCreated = try container.decode(Date.self, forKey: .dateCreated)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.ramenId, forKey: .ramenId)
        try container.encode(self.dateCreated, forKey: .dateCreated)
    }
    
}
