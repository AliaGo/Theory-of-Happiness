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
    @EnvironmentObject var userSession: UserSession
    @State private var showSignIn = false
    
    var body: some View {
        List {
            GroupingCastle(area:"北海道・東北", filteredCastles: viewModel.castles, showSignIn: $showSignIn)
            
            GroupingCastle(area:"関東・甲信越", filteredCastles: viewModel.castles, showSignIn: $showSignIn)
            
            GroupingCastle(area:"北陸・東海", filteredCastles: viewModel.castles, showSignIn: $showSignIn)

            GroupingCastle(area:"近畿", filteredCastles: viewModel.castles, showSignIn: $showSignIn)
            
            GroupingCastle(area:"中国・四国", filteredCastles: viewModel.castles, showSignIn: $showSignIn)
            
            GroupingCastle(area:"九州・沖縄", filteredCastles: viewModel.castles, showSignIn: $showSignIn)
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
        .fullScreenCover(isPresented: $showSignIn) {
            NavigationStack {
                AuthenticationView(allowGuest: false)
                    .environmentObject(userSession)
            }
        }
    }
}

struct GroupingCastle: View {
    @StateObject private var viewModel = CastleViewModel()
    
    @State private var showingDetail = false  //new
    
    @EnvironmentObject var userSession: UserSession
    
    var area: String
    
    var filteredCastles: [Castle]
    
    @Binding var showSignIn: Bool
    
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
                        if userSession.isSignedIn {
                            viewModel.addUserFavoriteCastle(castleId: c.id)
                        } else {
                            showSignIn = true  // ✅ 觸發登入頁
                        }
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

