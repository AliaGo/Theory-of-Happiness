//
//  FavoritesView.swift
//  TOH
//
//  Created by Alia on 2025/2/20.
//

import SwiftUI
import FirebaseAnalytics

@MainActor
final class FavoritesViewModel: ObservableObject {
    
    @Published private(set) var userFavoriteCastles: [UserFavoriteCastle] = []
    @Published private(set) var userFavoriteRamens: [UserFavoriteRamen] = []
    @Published private(set) var userFavoriteTWRamens: [UserFavoriteTWRamen] = []
    
    
    //同時獲取 fav castle 跟 fav ramen 跟 fav TWRamen 資料
    func getFavorites() {
        Task {
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            self.userFavoriteCastles = try await UserManager.shared.getAllUserFavoriteCastles(userId: authDataResult.uid)
            self.userFavoriteRamens = try await UserManager.shared.getAllUserFavoriteRamens(userId: authDataResult.uid)
            self.userFavoriteTWRamens = try await UserManager.shared.getAllUserFavoriteTWRamens(userId: authDataResult.uid)
        }
    }
    
    func removeCastleFromFavorites(favoriteCastleId: String) {
        Task {
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            try? await UserManager.shared.removeFavoriteCastle(userId: authDataResult.uid,favoriteCastleId: favoriteCastleId)
            
            getFavorites()
        }
        
    }
    
    func removeRamenFromFavorites(favoriteRamenId: String) {
        Task {
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            try? await UserManager.shared.removeFavoriteRamen(userId: authDataResult.uid,favoriteRamenId: favoriteRamenId)
            
            getFavorites()
        }
        
    }
    
    func removeTWRamenFromFavorites(favoriteTWRamenId: String) {
        Task {
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            try? await UserManager.shared.removeFavoriteTWRamen(userId: authDataResult.uid,favoriteTWRamenId: favoriteTWRamenId)
            
            getFavorites()
        }
        
    }
    
}

struct FavoritesView: View {
    
    @StateObject private var viewModel = FavoritesViewModel()
    @State private var currentSegment = "CASTLE"
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationStack{
                CustomSegmentedControl(selected: $selectedTab, options: [
                    ("Castle", AnyView(
                        List {
                        ForEach(viewModel.userFavoriteCastles, id:\.id.self) { item in
                            
                            CastleCellViewBuilder(castleId: String(item.castleId))
                                .contextMenu {
                                    Button("Remove from Favorites") {
                                        viewModel.removeCastleFromFavorites(favoriteCastleId: String(item.id))
                                    }
                                }

                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(role: .destructive) {
                                        viewModel.removeCastleFromFavorites(favoriteCastleId: String(item.id))
                                    } label: {
                                        Image(systemName: "trash")
                                    }
                                }
                            
                        }
                    }
                    )),
                        ("Ramen", AnyView(List {
                            ForEach(viewModel.userFavoriteRamens, id:\.id.self) { item in
                                
                                RamenCellViewBuilder(ramenId: String(item.ramenId))
                                    .contextMenu {
                                        Button("Remove from Favorites") {
                                            viewModel.removeRamenFromFavorites(favoriteRamenId: String(item.id))
                                        }
                                    }
                                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                        Button(role: .destructive) {
                                            viewModel.removeRamenFromFavorites(favoriteRamenId: String(item.id))
                                        } label: {
                                            Image(systemName: "trash")
                                        }
                                    }
                                
                            }
                        })),
                        ("TW Ramen", AnyView(List {
                            ForEach(viewModel.userFavoriteTWRamens, id:\.id.self) { item in
                                
                                TWRamenCellViewBuilder(ramenId: String(item.ramenId))
                                    .contextMenu {
                                        Button("Remove from Favorites") {
                                            viewModel.removeTWRamenFromFavorites(favoriteTWRamenId: String(item.id))
                                        }
                                    }
                                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                        Button(role: .destructive) {
                                            viewModel.removeTWRamenFromFavorites(favoriteTWRamenId: String(item.id))
                                        } label: {
                                            Image(systemName: "trash")
                                        }
                                    }
                                
                            }
                        }))
                    ])
                    .frame(maxWidth: .infinity)
                
            
            
        }
        .onAppear{
            viewModel.getFavorites()
            // 追蹤畫面瀏覽
            Analytics.logEvent(AnalyticsEventScreenView, parameters: [
                    AnalyticsParameterScreenName: "FavoritesView",
                    AnalyticsParameterScreenClass: "FavoritesView"
                  ])
        }
            
    }
}

#Preview {
    NavigationStack{
        FavoritesView()
    }
}


struct FavoriteCastleBlockView: View {
    var castle: Castle
    
    var body: some View {
        NavigationLink{
            CastleInfoView(castle: castle)
                
            
        } label: {
            HStack {
                AsyncImage(url: URL(string: castle.imageURL[0])) { image in
                    image
                        .resizable()
                        .cornerRadius(10)
                } placeholder: {
                    Color.black
                }
                .frame(width: 50, height: 50)
                .shadow(color:Color.black.opacity(0.4), radius: 4)
                
                VStack(alignment: .leading){
                    Text(castle.name)
                        .foregroundStyle(.primary)
                    
                    Text(castle.city)
                        .foregroundStyle(.secondary)
                }
                
            }
        }
    }
}


struct FavoriteRamenBlockView: View {
    var ramen: Ramen
    
    var body: some View {
        NavigationLink{
            RamenInfoView(ramen: ramen)
                
            
        } label: {
            HStack {
                AsyncImage(url: URL(string: ramen.imageURL[0])) { image in
                    image
                        .resizable()
                        .cornerRadius(10)
                } placeholder: {
                    Color.black
                }
                .frame(width: 50, height: 50)
                .shadow(color:Color.black.opacity(0.4), radius: 4)
                
                VStack(alignment: .leading){
                    Text(ramen.name)
                        .foregroundStyle(.primary)
                    
                    HStack {
                        Text(ramen.category.rawValue)
                            .foregroundStyle(.secondary)
                        
                        Text(ramen.city)
                            .foregroundStyle(.secondary)
                        
                        Text(ramen.station)
                            .foregroundStyle(.secondary)
                    }
                }
                
            }
        }
    }
}

struct FavoriteTWRamenBlockView: View {
    var ramen: TWRamen
    
    var body: some View {
        NavigationLink{
            TWRamenInfoView(ramen: ramen)
                
            
        } label: {
            HStack {
                AsyncImage(url: URL(string: ramen.reviewImageUrls?[0] ?? ramen.streetView)) { image in
                    image
                        .resizable()
                        .cornerRadius(10)
                } placeholder: {
                    Color.black
                }
                .frame(width: 50, height: 50)
                .shadow(color:Color.black.opacity(0.4), radius: 4)
                
                VStack(alignment: .leading){
                    Text(ramen.name)
                        .foregroundStyle(.primary)
                    
                    HStack {
                        Text(ramen.city)
                            .foregroundStyle(.secondary)
                        
                        Text(ramen.mrt)
                            .foregroundStyle(.secondary)
                    }
                }
                
            }
        }
    }
}

