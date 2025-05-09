
//
//  CastleManager.swift
//  TOH
//
//  Created by Alia on 2025/2/6.
//

import Foundation
import FirebaseFirestore
import SwiftUI
import CoreLocation

struct Castle: Hashable, Identifiable, Codable {
    var id : Int
    var name: String
    var jpName: String
    var area: String
    var city: String
    var address: String
    var access: String
    var description: String
    var isFavorite: Bool
    var isFeatured: Bool
    var url: String
    
    private var imageName: String
    var image: Image {
        Image(imageName)
    }
    
    var imageURL: [String]
    
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
    
    // CodingKey可以確保協作者不用去猜資料欄位的名稱

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case jpName = "jpName"
        case area = "area"
        case city = "city"
        case address = "address"
        case coordinates = "coordinates"
        case access = "access"
        case isFavorite = "isFavorite"
        case isFeatured = "isFeatured"
        case imageName = "imageName"
        case imageURL = "imageURL"
        case description = "description"
        case url = "url"
    }
    
    // mutate the struct from within the struct itself
    mutating func toggleFavorite() {
        let currentValue = isFavorite
        isFavorite = !currentValue
    }
    
    /*
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.jpName = try container.decode(String.self, forKey: .jpName)
        self.area = try container.decode(String.self, forKey: .area)
        self.city = try container.decode(String.self, forKey: .city)
        self.address = try container.decode(String.self, forKey: .address)
        self.coordinates = try container.decode(Coordinates.self, forKey: .coordinates)
        self.access = try container.decode(String.self, forKey: .access)
        self.isFavorite = try container.decode(Bool.self, forKey: .isFavorite)
        self.isFeatured = try container.decode(Bool.self, forKey: .isFeatured)
        self.imageName = try container.decode(String.self, forKey: .imageName)
        self.imageURL = try container.decode([String].self, forKey: .imageURL)
        self.description = try container.decode(String.self, forKey: .description)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.jpName, forKey: .jpName)
        try container.encode(self.area, forKey: .area)
        try container.encode(self.city, forKey: .city)
        try container.encode(self.address, forKey: .address)
        try container.encode(self.coordinates, forKey: .coordinates)
        try container.encode(self.access, forKey: .access)
        try container.encode(self.isFavorite, forKey: .isFavorite)
        try container.encode(self.isFeatured, forKey: .isFeatured)
        try container.encode(self.imageName, forKey: .imageName)
        try container.encode(self.imageURL, forKey: .imageURL)
        try container.encode(self.description, forKey: .description)
    }
     */
}




final class CastleManager {
    
    static let shared = CastleManager()
    private init() {}
    
    private let castleCollection = Firestore.firestore().collection("castles")
    
    private func castleDocument(castleId: String) -> DocumentReference {
        castleCollection.document(castleId)
    }
    
    func getCastle(castleId: String) async throws -> Castle {
        try await castleDocument(castleId: castleId).getDocument(as: Castle.self)
    }
    
    func getAllCastles() async throws -> [Castle] {
        try await castleCollection.getDocuments(as: Castle.self)
    }
    
    // 可以看影片第13,14學query跟filter
    private func getAllCastlesQuery() async throws -> Query {
        castleCollection
    }
    
}

extension Query {
    
    func getDocuments<T>(as type: T.Type) async throws -> [T] where T : Decodable {
        let snapshot = try await self.getDocuments()
        
        return try snapshot.documents.map({ document in
            try document.data(as: T.self)
        })
    }
}
