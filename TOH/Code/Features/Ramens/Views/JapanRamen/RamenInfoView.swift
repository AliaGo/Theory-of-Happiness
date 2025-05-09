//
//  RamenInfoView.swift
//  TOH
//
//  Created by Alia on 2025/2/19.
//

import Foundation

import SwiftUI
import MapKit

struct RamenInfoView: View {
    var ramen: Ramen

    var body: some View {
        //@Bindable var modelData = modelData
        
        
        ScrollView {
            /*
            MapView(coordinate: ramen.locationCoordinate, markerName: ramen.name)
            .frame(height: 300)
             */
            
            AsyncImage(url: URL(string: ramen.imageURL[0])) { image in
                image.resizable()
            } placeholder: {
                Color.black
            }
            .frame(height: 250)
                
            
            VStack(alignment: .leading) {
                HStack {
                    Text(ramen.name)
                        .font(.title)
                    //FavoriteButton(isSet: viewModel.ramens[ramenIndex].isFavorite)
                }
                HStack {
                    
                    AverageStarsView(rating: .constant(ramen.rating))
                    
                    Text(String(ramen.rating))
                    Image("ellipsis.message.fill")
                    Text(ramen.review)
                }
                HStack {
                    Text(ramen.address)
                        .font(.subheadline)
                    Spacer()
                    Text(ramen.city)
                        .font(.subheadline)
                }
                
                VStack(alignment: .leading){
                    Text("獲選百名店經歷：")
                        .font(.subheadline)
                    
                    HStack {
                        ForEach(ramen.year, id:\.self){ year in
                            Circle()
                                .frame(height:50)
                                .overlay(
                                    Text("百名店"+"\n"+String(year))
                                        .foregroundStyle(.white)
                                        .font(.system(.footnote, design: .rounded))
                                        .fontWeight(.heavy)
                                        .multilineTextAlignment(.center)
                                )

                        }
                    }
                }.padding(.top,5)
                
            
                Link("click to see more in 食べログ", destination: URL(string: ramen.url)!)
                /*
                HStack {
                    ForEach(ramen.tag, id:\.self){ tag in
                        Rectangle()
                            .overlay(
                                Text(tag)
                                    .foregroundStyle(.white)
                                    .font(.system(.footnote, design: .rounded))
                                    .fontWeight(.heavy)
                                    
                            )
                            .foregroundStyle(.myGreen2)
                            .frame(maxWidth:50, minHeight: 25,alignment: .leading)
                            .cornerRadius(45)
                        
                        
                    }
                    
                }
                */
                Divider()
                
                let columns = [GridItem(), GridItem(), GridItem()]
                
                ScrollView(.vertical, showsIndicators: false){
                    LazyVGrid(columns: columns) {
                            ForEach(ramen.imageURL, id:\.self){ url in
                                AsyncImage(url: URL(string: url)) { image in
                                    image.resizable()
                                } placeholder: {
                                    Color.black
                                }
                                .frame(width: 120, height: 100)
                                
                            }
                    }
                    
                }
                
                
                
            }.padding()
            
        }
        .navigationTitle(ramen.name)
        .navigationBarTitleDisplayMode(.inline)
        
    }
}

struct AverageStarsView: View {
    @Binding var rating: Double
    
    var body: some View {
        let starNum = rating / 1
        let num = Int(starNum)
        let range = 0..<num
        
        Group {
            ForEach(range, id: \.self) {_ in
                StarView(fillValue: 1)
            }
            StarView(fillValue: rating.truncatingRemainder(dividingBy: 1.0))
        }
        .frame(maxHeight: 16)
    }
}

struct StarView: View {
    var fillValue: Double
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                Rectangle()
                    .fill(Color.orange)
                    .frame(width: geometry.size.width * fillValue)
            }
        }
        .mask(
            Image(systemName: "star.fill")
                .resizable()
        )
        .aspectRatio(1, contentMode: .fit)
    }
}

#Preview {
    RamenInfoView(ramen: Ramen(id: 1, name: "ラーメン人生JET", city: "大阪", station: "福島駅", address: "大阪府大阪市福島区福島7-12-2", isFeatured: false, isFavorite: false, year: [2023], rating: 3.77, review: "2919", open: "11:00", url: "https://tabelog.com/osaka/A2701/A270108/27050827/", imageURL: ["https://tblg.k-img.com/restaurant/images/Rvw/113618/150x150_square_113618100.jpg", "https://tblg.k-img.com/restaurant/images/Rvw/113618/150x150_square_113618102.jpg","https://tblg.k-img.com/restaurant/images/Rvw/113618/150x150_square_113618103.jpg","https://tblg.k-img.com/restaurant/images/Rvw/113618/150x150_square_113618106.jpg","https://tblg.k-img.com/restaurant/images/Rvw/4689/150x150_square_4689386.jpg","https://tblg.k-img.com/restaurant/images/Rvw/4689/150x150_square_4689387.jpg","https://tblg.k-img.com/restaurant/images/Rvw/4689/150x150_square_4689388.jpg","https://tblg.k-img.com/restaurant/images/Rvw/4689/150x150_square_4689389.jpg","https://tblg.k-img.com/restaurant/images/Rvw/4689/150x150_square_4689390.jpg","https://tblg.k-img.com/restaurant/images/Rvw/4689/150x150_square_4689406.jpg","https://tblg.k-img.com/restaurant/images/Rvw/272655/150x150_square_d98d71475cb0a55fffe27e37cdeec163.jpg","https://tblg.k-img.com/restaurant/images/Rvw/272655/150x150_square_93728773cc8cdf502fdfb6bab4f00058.jpg","https://tblg.k-img.com/restaurant/images/Rvw/272655/150x150_square_4fa49f242964af836929ab7c0a6eac6a.jpg","https://tblg.k-img.com/restaurant/images/Rvw/272655/150x150_square_61db505146c37f50be6d3a1fec2f7c63.jpg","https://tblg.k-img.com/restaurant/images/Rvw/271186/150x150_square_dcf8abcc0652f9cccf76b1871c3c1046.jpg","https://tblg.k-img.com/restaurant/images/Rvw/271186/150x150_square_f014e13dee3501cf97f221149217af1c.jpg","https://tblg.k-img.com/restaurant/images/Rvw/270992/150x150_square_9e5bb17e9dddb1c0be3e433d482eb829.jpg","https://tblg.k-img.com/restaurant/images/Rvw/4689/150x150_square_4689364.jpg","https://tblg.k-img.com/restaurant/images/Rvw/4689/150x150_square_4689366.jpg","https://tblg.k-img.com/restaurant/images/Rvw/272655/150x150_square_ffe15ca4f94523c5a7a2e1af2cd34754.jpg"], category: Ramen.Category.osaka, imageName: "ラーメン人生JET"))
}

