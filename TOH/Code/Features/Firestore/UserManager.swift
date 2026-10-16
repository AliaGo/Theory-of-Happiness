//
//  UserManager.swift
//  TOH
//
//  Created by Alia on 2025/1/29.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
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
    let photos: [Photo]?
    let points: Int?
    let stamps: Int?
    let ranking: Int?
    let samuraiClan: String?
    let kamonName: String?
    let onboardingComplete: Bool?
    
    init(auth: AuthDataResultModel) {
        self.userId = auth.uid
        self.userNickname = auth.displayName
        self.email = auth.email
        self.photoUrl = auth.photoUrl
        self.dateCreated = Date()
        self.isPremium = false
        self.profileImagePath = nil
        self.profileImagePathUrl = nil
        self.photos = nil
        self.points = nil
        self.stamps = nil
        self.ranking = nil
        self.samuraiClan = nil
        self.kamonName = nil
        self.onboardingComplete = nil
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
        photos: [Photo]? = nil,
        points: Int? = nil,
        stamps: Int? = nil,
        ranking: Int? = nil,
        samuraiClan: String? = nil,
        kamonName: String? = nil,
        onboardingComplete: Bool? = nil
    ) {
        self.userId = userId
        self.userNickname = userNickname
        self.email = email
        self.photoUrl = photoUrl
        self.dateCreated = dateCreated
        self.isPremium = isPremium
        self.profileImagePath = profileImagePath
        self.profileImagePathUrl = profileImagePathUrl
        self.photos = photos
        self.points = points
        self.stamps = stamps
        self.ranking = ranking
        self.samuraiClan = samuraiClan
        self.kamonName = kamonName
        self.onboardingComplete = onboardingComplete
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
        case photos = "photos"
        case points = "points"
        case stamps = "stamps"
        case ranking = "ranking"
        case samuraiClan = "samurai_clan"
        case kamonName = "kamon_name"
        case onboardingComplete = "onboarding_complete"
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
        self.photos = try container.decodeIfPresent([Photo].self, forKey: .photos)
        self.points = try container.decodeIfPresent(Int.self, forKey: .points)
        self.stamps = try container.decodeIfPresent(Int.self, forKey: .stamps)
        self.ranking = try container.decodeIfPresent(Int.self, forKey: .ranking)
        self.samuraiClan = try container.decodeIfPresent(String.self, forKey: .samuraiClan)
        self.kamonName = try container.decodeIfPresent(String.self, forKey: .kamonName)
        self.onboardingComplete = try container.decodeIfPresent(Bool.self, forKey: .onboardingComplete)
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
        try container.encodeIfPresent(self.photos, forKey: .photos)
        try container.encodeIfPresent(self.points, forKey: .points)
        try container.encodeIfPresent(self.stamps, forKey: .stamps)
        try container.encodeIfPresent(self.ranking, forKey: .ranking)
        try container.encodeIfPresent(self.samuraiClan, forKey: .samuraiClan)
        try container.encodeIfPresent(self.kamonName, forKey: .kamonName)
        try container.encodeIfPresent(self.onboardingComplete, forKey: .onboardingComplete)
    }
    
}


final class UserManager {
    
    static let shared = UserManager()
    private init() {}
    
    private let userCollection: CollectionReference = Firestore.firestore().collection("users")
    
    private func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }

    private func leaderboardProfileDocument(userId: String) -> DocumentReference {
        Firestore.firestore().collection("leaderboard_profiles").document(userId)
    }
    
    // Collected Castle Stamps
    private func userCollectedStampsCollection(userId: String) -> CollectionReference {
        userDocument(userId: userId).collection("collected_stamps")
    }
    
    private func userCollectedStampsDocument(userId: String, castleId: String) -> DocumentReference {
        userCollectedStampsCollection(userId: userId).document(castleId)
    }

    // Castle visits are separate from stamps: users can record an attack without posting.
    private func userCastleVisitsCollection(userId: String) -> CollectionReference {
        userDocument(userId: userId).collection("castle_visits")
    }

    private func userCastleVisitDocument(userId: String, castleId: String) -> DocumentReference {
        userCastleVisitsCollection(userId: userId).document(castleId)
    }

    private func castleVisitorDocument(castleId: Int, userId: String) -> DocumentReference {
        Firestore.firestore().collection("castles").document(String(castleId)).collection("visitors").document(userId)
    }

    private func castleRatingDocument(castleId: Int, userId: String) -> DocumentReference {
        Firestore.firestore().collection("castles").document(String(castleId)).collection("ratings").document(userId)
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
 
    /// Firebase Auth 登入成功後，以 Firestore 的 users 文件判斷是否是第一次入城。
    func userProfileExists(userId: String) async throws -> Bool {
        try await userDocument(userId: userId).getDocument().exists
    }

    /// 只有完成新手入門的使用者才會建立 users 文件，避免半途離開留下未完成帳號資料。
    func createWarriorProfile(
        auth: AuthDataResultModel,
        nickname: String,
        clan: SamuraiClan
    ) async throws {
        let warrior = DBUser(
            userId: auth.uid,
            userNickname: nickname,
            email: auth.email,
            photoUrl: auth.photoUrl,
            dateCreated: Date(),
            isPremium: false,
            points: 0,
            stamps: 0,
            samuraiClan: clan.name,
            kamonName: clan.kamonName,
            onboardingComplete: true
        )
        try await userDocument(userId: auth.uid).setData(from: warrior, merge: false)
        await syncLeaderboardProfile(user: warrior)
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

    func chooseSamuraiClan(userId: String, clan: SamuraiClan) async throws {
        try await userDocument(userId: userId).updateData([
            DBUser.CodingKeys.samuraiClan.rawValue: clan.name,
            DBUser.CodingKeys.kamonName.rawValue: clan.kamonName,
            DBUser.CodingKeys.onboardingComplete.rawValue: true
        ])
        let updatedUser = try await getUser(userId: userId)
        await syncLeaderboardProfile(user: updatedUser)
    }

    /// 排行榜只讀取公開展示所需的資料，不公開 users 文件。
    func syncLeaderboardProfile(user: DBUser) async {
        do {
            try await leaderboardProfileDocument(userId: user.userId).setData([
                "nickname": user.userNickname ?? "攻城者",
                "photoUrl": user.profileImagePathUrl ?? "",
                "kamonName": user.kamonName ?? "",
                "samuraiClan": user.samuraiClan ?? "",
                "updatedAt": Timestamp()
            ], merge: true)
        } catch {
            print("⚠️ leaderboard profile sync failed: \(error)")
        }
    }
    
    func deleteAccount() async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.userAuthenticationRequired)
        }

        let userId = user.uid

        // 刪除 Firestore 使用者資料
        try await userDocument(userId: userId).delete()

        // 刪除 Firebase Authentication 使用者帳號
        try await AuthenticationManager.shared.deleteFirebaseAuthUser()
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

    // MARK: - Castle visits

    func getAllUserCastleVisits(userId: String) async throws -> [UserCastleVisit] {
        try await userCastleVisitsCollection(userId: userId)
            .order(by: UserCastleVisit.CodingKeys.visitedDate.rawValue, descending: true)
            .getDocuments(as: UserCastleVisit.self)
    }

    func hasVisitedCastle(userId: String, castleId: Int) async throws -> Bool {
        try await userCastleVisitDocument(userId: userId, castleId: String(castleId)).getDocument().exists
    }

    func getUserCastleVisit(userId: String, castleId: Int) async throws -> UserCastleVisit? {
        let snapshot = try await userCastleVisitDocument(userId: userId, castleId: String(castleId)).getDocument()
        guard snapshot.exists else { return nil }
        return try snapshot.data(as: UserCastleVisit.self)
    }

    func recordCastleVisit(
        userId: String,
        castleId: Int,
        castleName: String,
        visitedDate: Date,
        visitType: CastleVisitType,
        recommendationRating: Int,
        difficultyRating: Int,
        note: String
    ) async throws {
        let document = userCastleVisitDocument(userId: userId, castleId: String(castleId))
        let data: [String: Any] = [
            UserCastleVisit.CodingKeys.id.rawValue: document.documentID,
            UserCastleVisit.CodingKeys.castleId.rawValue: castleId,
            UserCastleVisit.CodingKeys.castleName.rawValue: castleName,
            UserCastleVisit.CodingKeys.visitedDate.rawValue: Timestamp(date: visitedDate),
            UserCastleVisit.CodingKeys.visitType.rawValue: visitType.rawValue,
            UserCastleVisit.CodingKeys.recommendationRating.rawValue: recommendationRating,
            UserCastleVisit.CodingKeys.difficultyRating.rawValue: difficultyRating,
            UserCastleVisit.CodingKeys.note.rawValue: note
        ]
        try await document.setData(data, merge: true)

        try await castleVisitorDocument(castleId: castleId, userId: userId).setData([
            "userId": userId,
            "createdAt": Timestamp()
        ], merge: true)

        try await castleRatingDocument(castleId: castleId, userId: userId).setData([
            "userId": userId,
            "recommendationRating": recommendationRating,
            "difficultyRating": difficultyRating,
            "updatedAt": Timestamp()
        ], merge: true)
    }

    func removeCastleVisit(userId: String, castleId: Int) async throws {
        try await userCastleVisitDocument(userId: userId, castleId: String(castleId)).delete()
        try await castleVisitorDocument(castleId: castleId, userId: userId).delete()
        try await castleRatingDocument(castleId: castleId, userId: userId).delete()
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

enum CastleVisitType: String, Codable {
    case stampOnly
    case paidEntry
    case fullConquest
    // 保留舊資料的值，讓既有攻城紀錄仍可正常讀取。
    case entered
    case outsideOnly

    var displayName: String {
        switch self {
        case .stampOnly: "僅蓋章"
        case .paidEntry: "付費參觀"
        case .fullConquest: "全攻略"
        case .entered: "全攻略"
        case .outsideOnly: "僅蓋章"
        }
    }
}

struct UserCastleVisit: Codable, Identifiable {
    let id: String
    let castleId: Int
    let castleName: String
    let visitedDate: Date
    let visitType: CastleVisitType
    let recommendationRating: Int?
    let difficultyRating: Int?
    let note: String?

    enum CodingKeys: String, CodingKey {
        case id
        case castleId
        case castleName
        case visitedDate
        case visitType
        case recommendationRating
        case difficultyRating
        case note
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
