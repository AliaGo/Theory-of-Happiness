//
//  TWRamenInfoView.swift
//  TOH
//
//  Created by Alia on 2025/5/6.
//

import SwiftUI

struct TWRamenInfoView: View {
    
    var ramen: TWRamen
    
    var body: some View {
        ScrollView {
            /*
            MapView(coordinate: ramen.locationCoordinate, markerName: ramen.name)
            .frame(height: 300)
             */
            
            AsyncImage(url: URL(string: ramen.photo)) { image in
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
                    Text(String(ramen.reviews))
                }
                
                HStack{
                    Image(systemName: "mappin.and.ellipse.circle")
                    Text(ramen.fullAddress)
                        .font(.footnote)
                }
                
                
                HStack {
                    Image(systemName: "tram.circle.fill")
                    
                    Text(ramen.mrt)
                        .font(.subheadline)
                        .padding(.trailing, 5)
                    
                    Image(systemName: "figure.walk")
                    Text(ramen.walkDistance)
                        .font(.footnote)
                        .padding(.trailing, 3)
                    Text(ramen.walkTime)
                        .font(.footnote)
                    
                    
                    Spacer()
                    
                    ForEach(ramen.mrtLine, id: \.self) { line in
                        Text(line)
                            .font(.footnote)
                    }
                }
                
                Link("click to see in Google Map", destination: URL(string: ramen.locationLink)!)
                
                if let workingHours = ramen.workingHoursOldFormat {
                    Text(workingHours)
                        .font(.footnote)
                        .foregroundStyle(Color.gray)
                }
                
                if let menu = ramen.foodRegular {
                    HStack(spacing: 3) {
                        Image(systemName: "menucard")
                        ForEach(menu, id: \.self){ ramen in
                            Text(ramen.replacingOccurrences(of: ",", with: ""))
                                .font(.subheadline)
                        }
                    }
                    
                }
                
                if let site = ramen.site {
                    HStack {
                        Image(systemName: "globe")
                        Link("社群網站", destination: URL(string: site)!)
                    }
                }
                
                
                
                
                
                
                let rows = [GridItem(), GridItem()]
                
                LazyHGrid(rows: rows) {
                    ForEach(ramen.reviewsTags, id:\.self){ tag in
                        Rectangle()
                            .overlay(
                                Text(tag.replacingOccurrences(of: ",", with: ""))
                                    .padding(.vertical, 2)
                                    .foregroundStyle(.white)
                                    .font(.system(.footnote, design: .rounded))
                                    .fontWeight(.heavy)
                                    
                            )
                            .foregroundStyle(.myGreen2)
                            .frame(minWidth:70, minHeight: 25,alignment: .leading)
                            .cornerRadius(45)
                        
                        
                    }
                    
                }
                
                Divider()
                
                let columns = [GridItem(), GridItem(), GridItem()]
                
                ScrollView(.vertical, showsIndicators: false){
                    LazyVGrid(columns: columns) {
                        if let urls = ramen.reviewImageUrls {
                            ForEach(urls, id:\.self){ url in
                                AsyncImage(url: URL(string: url)) { image in
                                    image.resizable()
                                } placeholder: {
                                    Color.black
                                }
                                .frame(width: 120, height: 100)
                                //.clipShape(.rect(cornerRadius: 25))
                            }
                        }
                        
                    }
                    
                }
                
                
                
            }.padding()
            
        }
        .navigationTitle(ramen.name)
        .navigationBarTitleDisplayMode(.inline)
        
    }
}
