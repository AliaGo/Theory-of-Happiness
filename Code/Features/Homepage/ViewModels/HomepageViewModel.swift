//
//  HomepageViewModel.swift
//  TOH
//
//  Created by Alia on 2025/2/6.
//

import Foundation
import FirebaseCore
import FirebaseFirestore


@MainActor
final class HomepageViewModel: ObservableObject {
    
    @Published var castles = [Castle]()
    @Published var ramens = [Ramen]()
    
    private var db = Firestore.firestore()
    
    /*
    func fetchData() async throws {
        do {
          let castles = try await db.collection("castles").getDocuments()
          let ramens = try await db.collection("ramens").getDocuments()
          for document in castles.documents {
            print("\(document.documentID) => \(document.data())")
          }
          for document in ramens.documents {
            print("\(document.documentID) => \(document.data())")
          }
        } catch {
          print("Error getting documents: \(error)")
        }
    }
     */
    
    func fetchData() async throws {
        self.castles = try await CastleManager.shared.getAllCastles()
        self.ramens = try await RamenManager.shared.getAllramens()
    }
}
