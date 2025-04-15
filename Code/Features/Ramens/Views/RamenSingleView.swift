//
//  RamenView.swift
//  TOH
//
//  Created by Alia on 2025/2/6.
//

import SwiftUI

struct RamenSingleView: View {
    //@StateObject private var viewModel = RamenViewModel()
    var ramen: Ramen
    
    /*
    var ramenIndex: Int {
        viewModel.ramens.firstIndex(where: { $0.id == ramen.id })!
    }
    */
    var body: some View {
        //@Bindable var modelData = modelData
        
        VStack {
            Rectangle()
                .aspectRatio(6/3, contentMode: .fill)
            .overlay {
                AsyncImage(url: URL(string: ramen.imageURL[0])) { image in
                    image.resizable()
                } placeholder: {
                    Color.black
                }
                .scaledToFill()
            }
            .clipped()
            .frame(width: 180, height: 80)
            .padding(.bottom, 10)
            
            VStack(spacing:10){
                Text(ramen.name)
                    .font(.system(size: 14, design: .rounded))
                    .fontWeight(.bold)
                    .padding(.bottom, -5)
                    .frame(alignment: .leading)
                
                /*
                HStack {
                    ForEach(ramen.tag, id:\.self){ tag in
                        Rectangle()
                            .overlay(
                                Text(tag)
                                    .foregroundStyle(.white)
                                    .font(.system(size: 10, design: .rounded))
                                    .fontWeight(.heavy)
                                    
                            )
                            .foregroundStyle(.myGreen2)
                            .frame(maxWidth:50, maxHeight: 20,alignment: .leading)
                            .cornerRadius(45)
                        
                        
                    }
                    
                }
                .padding(.bottom, -10)
                */
                HStack{
                    Image("starFill")
                    Text(String(ramen.rating))
                        .fontWeight(.semibold)
                        .font(.system(size: 12, design: .rounded))
                    Image(systemName: "ellipsis.message")
                    Text(ramen.review)
                        .fontWeight(.semibold)
                        .font(.system(size: 12, design: .rounded))
                }
                
            }
            
            
        }
        .frame(width: 180, height: 150)
        .foregroundStyle(.black)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(color: Color.black.opacity(0.2), radius: 7, x: 0, y: 2)
        
        /*
        .overlay(alignment: .topTrailing) {
            FavoriteButton(isSet: $modelData.ramens[ramenIndex].isFavorite)
                .padding(.trailing, 5)
                .padding(.top, 5)
        }
         */
    }
}


#Preview {
    RamenSingleView(ramen: Ramen(id: 1, name: "ラーメン人生JET", city: "大阪", station: "福島駅", address: "大阪府大阪市福島区福島7-12-2", isFeatured: false, isFavorite: false, year: [2023], rating: 3.77, review: "2919", open: "11:00", url: "https://tabelog.com/osaka/A2701/A270108/27050827/", imageURL: ["https://tblg.k-img.com/restaurant/images/Rvw/113618/150x150_square_113618100.jpg", "https://tblg.k-img.com/restaurant/images/Rvw/113618/150x150_square_113618102.jpg"], category: Ramen.Category.osaka, imageName: "ラーメン人生JET"))
}


