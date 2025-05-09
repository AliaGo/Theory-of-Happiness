//
//  TWCategoryItem.swift
//  TOH
//
//  Created by Alia on 2025/5/7.
//

import SwiftUI

struct TWCategoryItem: View {
    @StateObject private var viewModel = TWRamenViewModel()
    
    var ramen: TWRamen
    
    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: URL(string: ramen.reviewImageUrls?[0] ?? ramen.photo)) { image in
                image
                    .resizable()
                    .renderingMode(.original)
            } placeholder: {
                Color.black
            }
                .frame(width: 180, height: 150)
                .cornerRadius(5)
                .overlay(alignment: .topTrailing) {
                    Button {
                        viewModel.addUserFavoriteTWRamen(ramenId: ramen.id)
                    } label: {
                        Capsule()
                            .fill(.white)
                            .frame(width: 30, height: 30)
                            .overlay(alignment: .center) {
                                Label("Toggle Favorite", systemImage: "heart.fill")
                                    .labelStyle(.iconOnly)
                                    .foregroundStyle(.red)
                            }
                        
                            
                    }
                }
            
            
            Text(ramen.name)
                .foregroundStyle(.black)
                .font(.caption)
                
            
            HStack(spacing:5) {
                Image(systemName: "star.circle")
                Text(String(ramen.rating))
                    .fontWeight(.semibold)
                    .font(.caption)
                
                Image(systemName: "ellipsis.message.fill")
                Text(String(ramen.reviews))
                    .fontWeight(.semibold)
                    .font(.caption)
                
                Image(systemName: "tram.circle")
                    .foregroundColor(.myGreen2)
                Text(ramen.mrt)
                    .foregroundStyle(.myGreen2)
                    .font(.caption)
            }
            .padding(.bottom, 5)
        }
        .padding(.leading, 15)
    }
}

