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
        VStack(spacing: 0) {
            // 上方圖片
            AsyncImage(url: URL(string: ramen.reviewImageUrls?[1] ?? ramen.streetView)) { image in
                image
                    .resizable()
                    .scaledToFill() // 保持比例，超出裁切
                    .frame(height: 80) // 固定圖片高度
                    .clipped()
            } placeholder: {
                Color.black.frame(height: 80)
            }

            // 下方白底資訊
            VStack(spacing: 10) {
                Text(ramen.name)
                    .font(.system(size: 14, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundStyle(.black)
                    .padding(.bottom, -5)
                    .frame(maxWidth: .infinity, alignment: .leading)

                HStack {
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
            .padding()
            .background(Color.white)
        }
        .frame(width: 180, height: 150) // 整張卡片大小
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(color: Color.black.opacity(0.2), radius: 7, x: 0, y: 2)
        
        
    }
}

