
//
//  RamenManager.swift
//  TOH
//
//  Created by Alia on 2025/2/6.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import CoreLocation


struct Ramen: Hashable, Identifiable, Codable {
    var id : Int
    var name: String
    var city: String
    var station: String
    var address: String
    var isFeatured: Bool
    var isFavorite: Bool
    var year: [Int]
    var rating: Double
    var review: String
    //var tag: [String]
    var open: String
    var url: String
    var imageURL: [String]
    
    
    var category: Category
    enum Category: String, CaseIterable, Codable {
        case tokyo = "Tokyo"
        case osaka = "Osaka"
        case east = "East"
        case west = "West"
    }
    
    private var imageName: String
    var image: Image {
        Image(imageName)
    }
    
    var featureImage: Image? {
        isFeatured ? Image(imageName + "_feature") : nil
    }
    
    init(
        id : Int,
        name: String,
        city: String,
        station: String,
        address: String,
        isFeatured: Bool,
        isFavorite: Bool,
        year: [Int],
        rating: Double,
        review: String,
        //var tag: [String]
        open: String,
        url: String,
        imageURL: [String],
        category: Category,
        imageName: String
        
    ) {
        self.id = id
        self.name = name
        self.city = city
        self.station = station
        self.address = address
        self.isFavorite = isFavorite
        self.isFeatured = isFeatured
        self.year = year
        self.rating = rating
        self.review = review
        self.open = open
        self.url = url
        self.imageURL = imageURL
        self.category = category
        self.imageName = imageName
    }
    
    /*
    var coordinates: Coordinates
    var locationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: coordinates.latitude,
            longitude: coordinates.longitude)
    }
    
    struct Coordinates: Hashable, Codable {
        var latitude: Double
        var longitude: Double
    }
    
    struct Opentimes: Hashable, Codable {
        var Mon: String
        var Tue: String
        var Wed: String
        var Thu: String
        var Fri: String
        var Sat: String
        var Sun: String
    }
     */
}

final class RamenManager {
    
    static let shared = RamenManager()
    private init() {}
    
    private let ramenCollection = Firestore.firestore().collection("ramens")
    
    private func ramenDocument(ramenId: String) -> DocumentReference {
        ramenCollection.document(ramenId)
    }
    
    func getRamen(ramenId: String) async throws -> Ramen {
        try await ramenDocument(ramenId: ramenId).getDocument(as: Ramen.self)
    }
    
    func getAllramens() async throws -> [Ramen] {
        try await ramenCollection.getDocuments(as: Ramen.self)
    }
    
    // 可以看影片第13,14學query跟filter
    private func getAllRamensQuery() async throws -> Query {
        ramenCollection
    }
    
}
