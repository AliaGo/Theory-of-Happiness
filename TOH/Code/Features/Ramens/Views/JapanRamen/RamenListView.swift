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
        if ramens.isEmpty {
            Text("No ramen data available.") // 如果没有数据，显示提示
        } else {
            Text("有") // 查看传递过来的数据
        }
        
        
        NavigationSplitView{
            List{
                if features.count != 0{
                    PageView(pages: features.map { FeatureCard(ramen: $0) })
                        .listRowInsets(EdgeInsets())
                }
                
                ForEach(categories.keys.sorted(), id: \.self) { key in
                    CategoryRow(categoryName: key, items: categories[key]!)
                }
                .listRowInsets(EdgeInsets())
                
                
            }
            .listStyle(.inset)
            .navigationTitle("Ramen 100")
            
        } detail: {
            Text("Select a Landmark")
        }
        .padding(.top, -40)
        .searchable(text: $searchText, prompt: "Search for a ramen")
        .onAppear {
            // 追蹤畫面瀏覽
            Analytics.logEvent(AnalyticsEventScreenView, parameters: [
                    AnalyticsParameterScreenName: "RamenListView",
                    AnalyticsParameterScreenClass: "RamenListView"
                  ])
        }
        /*
         .task{
         try? await viewModel.getAllRamens()
         }
         */
         
    }
}

 
 
