//
//  TaiwanRamenManager.swift
//  TOH
//
//  Created by Alia on 2025/5/6.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import CoreLocation


// 目前只有台北拉麵
struct TWRamen: Hashable, Identifiable, Codable {
    let id: String
    let name: String
    let site: String?
    let phone: String?
    let fullAddress: String
    let mrt: String
    let street: String
    let city: String
    let latitude: Double
    let longitude: Double
    let rating: Double
    let reviews: Int
    let reviewsLink: String
    let reviewsTags: [String]
    let photosCount: Int
    let photo: String
    let streetView: String
    let reviewImageUrls: [String]?
    let workingHours: String?
    let workingHoursOldFormat: String?
    let logo: String?
    let locationLink: String
    let walkDistance: String
    let walkTime: String
    let foodRegular: [String]?
    let foodLimited: [String]?
    let mrtLine: [String]

    
    // 定义映射规则：确保 JSON 键和模型属性名称匹配
    enum CodingKeys: String, CodingKey {
        case name
        case site
        case phone
        case fullAddress = "full_address"
        case mrt
        case street
        case city
        case latitude
        case longitude
        case rating
        case reviews
        case reviewsLink = "reviews_link"
        case reviewsTags = "reviews_tags"
        case photosCount = "photos_count"
        case photo
        case streetView = "street_view"
        case reviewImageUrls = "review_image_urls"
        case workingHours = "working_hours"
        case workingHoursOldFormat = "working_hours_old_format"
        case logo
        case locationLink = "location_link"
        case walkDistance = "walk_distance"
        case walkTime = "walk_time"
        case foodRegular = "food_regular"
        case foodLimited = "food_limited"
        case mrtLine = "mrt_line"
        case id
    }

    // 初始化
    init(name: String, site: String?, phone: String?, fullAddress: String, mrt: String, street: String, city: String, latitude: Double, longitude: Double, rating: Double, reviews: Int, reviewsLink: String, reviewsTags: [String], photosCount: Int, photo: String, streetView: String, reviewImageUrls:[String]?, workingHours: String?, workingHoursOldFormat: String?, logo: String?, locationLink: String, walkDistance: String, walkTime: String, foodRegular: [String]?, foodLimited: [String]?, mrtLine: [String], id: String) {
        self.name = name
        self.site = site
        self.phone = phone
        self.fullAddress = fullAddress
        self.mrt = mrt
        self.street = street
        self.city = city
        self.latitude = latitude
        self.longitude = longitude
        self.rating = rating
        self.reviews = reviews
        self.reviewsLink = reviewsLink
        self.reviewsTags = reviewsTags
        self.photosCount = photosCount
        self.photo = photo
        self.streetView = streetView
        self.reviewImageUrls = reviewImageUrls
        self.workingHours = workingHours
        self.workingHoursOldFormat = workingHoursOldFormat
        self.logo = logo
        self.locationLink = locationLink
        self.walkDistance = walkDistance
        self.walkTime = walkTime
        self.foodRegular = foodRegular
        self.foodLimited = foodLimited
        self.mrtLine = mrtLine
        self.id = id
    }
    
}



final class TWRamenManager {
    
    static let shared = TWRamenManager()
    private init() {}
    
    private let ramenCollection = Firestore.firestore().collection("taiwanRamens")
    
    private func ramenDocument(ramenId: String) -> DocumentReference {
        ramenCollection.document(ramenId)
    }
    
    func getTWRamen(ramenId: String) async throws -> TWRamen {
        try await ramenDocument(ramenId: ramenId).getDocument(as: TWRamen.self)
    }
    
    func getAllTWRamens() async throws -> [TWRamen] {
        try await ramenCollection.getDocuments(as: TWRamen.self)
    }
    
    // 可以看影片第13,14學query跟filter
    private func getAllTaiwanRamensQuery() async throws -> Query {
        ramenCollection
    }
    
}
