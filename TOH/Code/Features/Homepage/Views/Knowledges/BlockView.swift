//
//  BlockView.swift
//  TOH
//
//  Created by Alia on 2025/2/19.
//

import Foundation
import SwiftUI

struct BlockView: View {
    var blockName: String
    var blockImg: String
    var backgroundColor: Color
    var frontColor: Color
    
    var gradient: LinearGradient {
        .linearGradient(
            Gradient(colors: [.black.opacity(0.6), .black.opacity(0)]),
            startPoint: .bottom,
            endPoint: .center)
    }
    
    var body: some View {
        
        
        ZStack {
            Image(blockImg)
                .resizable()
                .scaledToFill()
                .opacity(0.5)
            
            gradient
            Text(blockName)
                .font(.system(size: 20, design: .rounded))
                .fontWeight(.bold)
                .padding(.bottom, -5)
                .frame(alignment: .leading)
                .shadow(color: Color.white.opacity(0.5), radius: 7, x: 0, y: 2)
        }
        .frame(width: 210, height: 140)
        .padding(.bottom, 3)
        .foregroundStyle(frontColor)
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(color: Color.black.opacity(0.2), radius: 7, x: 0, y: 2)
        
    }
    
}

#Preview("RamenBlockView") {
    BlockView(blockName: "日本城用語辭典", blockImg: "城堡辭典", backgroundColor: .white, frontColor: .black)
}

