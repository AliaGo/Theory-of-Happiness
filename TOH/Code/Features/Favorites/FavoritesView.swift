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
    @State private var selectedTab = 0
    
    
    var body: some View {
        NavigationStack {
            CustomSegmentedControl(selected: $selectedTab, options: [
                ("城堡", AnyView(castleFavorites)),
                ("拉麵", AnyView(ramenFavorites))
            ])
            .frame(maxWidth: .infinity)
            .navigationTitle("我的最愛")
            .navigationBarTitleDisplayMode(.inline)
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

    private var castleFavorites: some View {
        List {
            if viewModel.userFavoriteCastles.isEmpty {
                favoriteEmptyState("還沒有想攻下的城堡", symbol: "building.columns")
            } else {
                Section("想攻下的城堡") {
                    ForEach(viewModel.userFavoriteCastles, id: \.id) { item in
                        CastleCellViewBuilder(castleId: String(item.castleId))
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    viewModel.removeCastleFromFavorites(favoriteCastleId: item.id)
                                } label: {
                                    Label("取消收藏", systemImage: "heart.slash")
                                }
                            }
                    }
                }
            }
        }
    }

    private var ramenFavorites: some View {
        List {
            if viewModel.userFavoriteRamens.isEmpty && viewModel.userFavoriteTWRamens.isEmpty {
                favoriteEmptyState("還沒有收藏的拉麵", symbol: "fork.knife")
            } else {
                if !viewModel.userFavoriteRamens.isEmpty {
                    Section("日本拉麵") {
                        ForEach(viewModel.userFavoriteRamens, id: \.id) { item in
                            RamenCellViewBuilder(ramenId: String(item.ramenId))
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(role: .destructive) {
                                        viewModel.removeRamenFromFavorites(favoriteRamenId: item.id)
                                    } label: {
                                        Label("取消收藏", systemImage: "heart.slash")
                                    }
                                }
                        }
                    }
                }

                if !viewModel.userFavoriteTWRamens.isEmpty {
                    Section("台灣拉麵") {
                        ForEach(viewModel.userFavoriteTWRamens, id: \.id) { item in
                            TWRamenCellViewBuilder(ramenId: item.ramenId)
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(role: .destructive) {
                                        viewModel.removeTWRamenFromFavorites(favoriteTWRamenId: item.id)
                                    } label: {
                                        Label("取消收藏", systemImage: "heart.slash")
                                    }
                                }
                        }
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func favoriteEmptyState(_ title: String, symbol: String) -> some View {
        ContentUnavailableView(title, systemImage: symbol, description: Text("從探索頁開始收藏吧"))
            .listRowSeparator(.hidden)
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
