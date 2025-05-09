//
//  TaiwanRamenSingleView.swift
//  TOH
//
//  Created by Alia on 2025/5/6.
//

import SwiftUI

struct TWRamenSingleView: View {
    
    var ramen: TWRamen
    
    var body: some View {
        VStack {
            Rectangle()
                .aspectRatio(6/3, contentMode: .fill)
            .overlay {
                AsyncImage(url: URL(string: ramen.reviewImageUrls?[1] ?? ramen.streetView)) { image in
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
                    Text(String(ramen.reviews))
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
        
    }
}

