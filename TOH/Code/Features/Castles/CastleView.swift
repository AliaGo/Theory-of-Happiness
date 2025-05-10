//
//  CastleView.swift
//  TOH
//
//  Created by Alia on 2025/2/6.
//

import SwiftUI
import FirebaseAnalytics

struct CastleView: View {
    
    @StateObject private var viewModel = CastleViewModel()
    
    
    var body: some View {
        List {
            GroupingCastle(area:"北海道・東北", filteredCastles: viewModel.castles)
            
            GroupingCastle(area:"関東・甲信越", filteredCastles: viewModel.castles)
            
            GroupingCastle(area:"北陸・東海", filteredCastles: viewModel.castles)

            GroupingCastle(area:"近畿", filteredCastles: viewModel.castles)
            
            GroupingCastle(area:"中国・四国", filteredCastles: viewModel.castles)
            
            GroupingCastle(area:"九州・沖縄", filteredCastles: viewModel.castles)
        }
        .navigationTitle("Castles")
        .onAppear {
            // 追蹤畫面瀏覽
            Analytics.logEvent(AnalyticsEventScreenView, parameters: [
                    AnalyticsParameterScreenName: "CastleView",
                    AnalyticsParameterScreenClass: "CastleView"
                  ])
        }
        .task{
            try? await viewModel.getAllCastles()
        }
    }
}

struct GroupingCastle: View {
    @StateObject private var viewModel = CastleViewModel()
    
    @State private var showingDetail = false  //new
    
    var area: String
    
    var filteredCastles: [Castle]
    
    var body: some View {
        Section(header: Text(area)){
            ForEach(filteredCastles.filter {i in (i.area == area)}) { c in
                NavigationLink{
                    CastleInfoView(castle: c)
                        
                    
                } label: {
                    HStack {
                        AsyncImage(url: URL(string: c.imageURL[0])) { image in
                            image
                                .resizable()
                                .cornerRadius(10)
                        } placeholder: {
                            Color.black
                        }
                        .frame(width: 50, height: 50)
                        .shadow(color:Color.black.opacity(0.4), radius: 4)
                        
                        VStack(alignment: .leading){
                            Text(c.name)
                                .foregroundStyle(.primary)
                            
                            Text(c.city)
                                .foregroundStyle(.secondary)
                        }
                        //Spacer()
                        
                        /*
                        if c.isFavorite {
                            Image(systemName: "heart.fill")
                                .foregroundStyle(.red)
                        }
                         */
                    }
                }
                .contextMenu {
                    Button("Add to Favorites") {
                        viewModel.addUserFavoriteCastle(castleId: c.id)
                    }
                }
            }
        }
    }
}


#Preview {
    NavigationStack{
        CastleView()
    }
}

