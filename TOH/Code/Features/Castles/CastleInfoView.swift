//
//  CastleInfoView.swift
//  TOH
//
//  Created by Alia on 2025/2/17.
//

import SwiftUI
import MapKit

struct CastleInfoView: View {
    //@EnvironmentObject var isFavorite: Binding<Bool>
    @StateObject private var viewModel = CastleViewModel()
    
    // 控制全螢幕顯示
    @State private var showFullScreen = false
    @State private var selectedIndex = 0
    
    var castle: Castle
    //var isFavorite: Bool

    var areaIndex: Int {
        viewModel.castles.firstIndex(where: { $0.id == (castle.id)/1000 })!
    }
    var castleIndex: Int {
        viewModel.castles.firstIndex(where: { $0.id == castle.id })!
    }
    
    var isFavorite: Bool {
        viewModel.isFavorite
    }

    var body: some View {
        //@Bindable var viewModel = viewModel
        //@Binding var isFavorite = isFavorite
        
        
        ScrollView {
            MapView(coordinate: castle.locationCoordinate, markerName: castle.name)
            .frame(height: 300)
            
            AsyncImage(url: URL(string: castle.imageURL[0])) { image in
                image.resizable()
            } placeholder: {
                Color.black
            }
            .frame(maxWidth: 200, maxHeight: 200)
            .clipShape(Circle())
            .overlay {
                Circle().stroke(.white, lineWidth: 4)
            }
            .shadow(radius: 7)
            .offset(y: -130)
            .padding(.bottom, -130)
            
            
            VStack(alignment: .leading) {
                HStack {
                    Text(castle.name)
                        .font(.title)
                    
                    
                    if isFavorite == true {
                        Label("Toggle Favorite", systemImage: "heart.fill")
                            .labelStyle(.iconOnly)
                            .foregroundStyle(.red)
                    }
                }
                
                 
                Text(castle.jpName)
                    .font(.title3)
                
                HStack {
                    Text(castle.address)
                        .font(.subheadline)
                    Spacer()
                    Text(castle.city)
                        .font(.subheadline)
                }
                
                VStack(alignment: .leading){
                    Text("交通/印章設置場所/入館費用:")
                        .font(.subheadline)
                    Text(castle.access)
                        .font(.subheadline)
                }.padding(.top,5)
                
                Link("click to see more in homepage", destination: URL(string: castle.url)!)
                
                Divider()
                
                Text("Introduction：")
                    .font(.title2)
                Text(castle.description)
                        .font(.footnote)
                
                HStack {
                    ForEach(Array(castle.imageURL.enumerated()), id: \.offset){ idx, urlString in
                        AsyncImage(url: URL(string: urlString)) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            Color.gray.opacity(0.3)
                        }
                        .frame(width: (UIScreen.main.bounds.width-48)/5,
                               height: (UIScreen.main.bounds.width-48)/5)
                        .clipped()
                        .cornerRadius(8)
                        .onTapGesture {
                            selectedIndex = idx
                            showFullScreen = true
                        }
                        //.clipShape(.rect(cornerRadius: 25))
                    }
                }
                
                
            }.padding()
            .ignoresSafeArea()
            .fullScreenCover(isPresented: $showFullScreen) {
                FullscreenImageViewer(urls: castle.imageURL, selectedIndex: selectedIndex)
            }
        }
        .navigationTitle(castle.name)
        .navigationBarTitleDisplayMode(.inline)
        .task{
            try? await viewModel.getAllCastles()
            try? await viewModel.checkUserFavoriteCastle(castleId: castle.id)
        }
        
    }
}


