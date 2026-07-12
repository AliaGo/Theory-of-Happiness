//
//  TWRamenInfoView.swift
//  TOH
//
//  Created by Alia on 2025/5/6.
//

import SwiftUI

struct TWRamenInfoView: View {
    
    var ramen: TWRamen
    
    // 圖片縮放
    @State private var selectedIndex: Int? = nil
    @State private var showFullScreen = false
    
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
                
                
                
                
                /*
                let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
                
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVGrid(columns: columns, spacing: 8) {
                        if let urls = ramen.reviewImageUrls {
                            ForEach(Array(urls.enumerated()), id: \.offset) { index, url in
                                AsyncImage(url: URL(string: url)) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 120, height: 100)
                                        .clipped()
                                        .onTapGesture {
                                            selectedIndex = index
                                            showFullScreen = true
                                        }
                                } placeholder: {
                                    Color.gray
                                        .frame(width: 120, height: 100)
                                }
                            }
                        }
                    }
                }
                .fullScreenCover(isPresented: $showFullScreen) {
                    if let urls = ramen.reviewImageUrls, let selectedIndex = selectedIndex {
                        ZStack {
                            Color.black.opacity(0.9).ignoresSafeArea()

                            TabView(selection: $selectedIndex) {
                                ForEach(0..<urls.count, id: \.self) { index in
                                    AsyncImage(url: URL(string: urls[index])) { image in
                                        image
                                            .resizable()
                                            .scaledToFit() // 確保比例正確
                                            .padding()
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    .tag(index)
                                }
                            }
                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // 隱藏底部分頁點

                            // 關閉按鈕
                            VStack {
                                HStack {
                                    Spacer()
                                    Button(action: { showFullScreen = false }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                            .foregroundColor(.white.opacity(0.8))
                                            .padding()
                                    }
                                }
                                Spacer()
                            }
                        }
                    }
                }
                 */
                
                
                
            }.padding()
            
            if let urls = ramen.reviewImageUrls {
                ImageGalleryView(urls: urls)
                    .padding()
                    .edgesIgnoringSafeArea(.all)
            }
        }
        .navigationTitle(ramen.name)
        .navigationBarTitleDisplayMode(.inline)
        
    }
}
