//
//  RamenListView.swift
//  TOH
//
//  Created by Alia on 2025/2/6.
//

import Foundation
import SwiftUI
import FirebaseAnalytics

// 因為不知名原因這個無法執行，改寫在homepageview下方

struct RamenListView2: View {
    @StateObject private var viewModel = RamenViewModel()
    let ramens: [Ramen]
    @State private var searchText = ""
    @EnvironmentObject var userSession: UserSession
    @State private var showSignIn = false
    
    var filteredRamens: [Ramen] {
        if searchText.isEmpty {
            return ramens
        } else {
            return ramens.filter { $0.name.localizedStandardContains(searchText) ||
                $0.city.localizedStandardContains(searchText) ||
                $0.station.localizedStandardContains(searchText)
            }
        }
    }
    
    var features: [Ramen] {
        ramens.filter { $0.isFeatured }
    }
    
    var categories: [String: [Ramen]] {
        Dictionary(
            grouping: filteredRamens,
            by: { $0.category.rawValue }
        )
    }
    
    var body: some View {
            List{
                if features.count != 0{
                    PageView(pages: features.map { FeatureCard(ramen: $0) })
                        .listRowInsets(EdgeInsets())
                }
                
                ForEach(categories.keys.sorted(), id: \.self) { key in
                    CategoryRow(categoryName: key, items: categories[key]!){
                        showSignIn = true // 按下Fav按鈕需要登入時顯示登入畫面
                    }
                }
                .listRowInsets(EdgeInsets())
                
                
            }
            .listStyle(.inset)
            .navigationTitle("Ramen 100")
            .searchable(text: $searchText, prompt: "Search for a ramen")
            .fullScreenCover(isPresented: $showSignIn) {
                NavigationStack {
                    AuthenticationView(allowGuest: false)
                        .environmentObject(userSession)
                }
            }
        
        
        /*
         .task{
         try? await viewModel.getAllRamens()
         }
         */
         
    }
}

 
 
