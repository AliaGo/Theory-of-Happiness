//
//  StampBookView.swift
//  TOH
//
//  Created by Alia on 2025/2/28.
//

import SwiftUI

struct StampBookView: View {
    var blockName: String
    var blockImg: String
    var backgroundColor: Color
    var frontColor: Color
    
    
    var gradient: LinearGradient {
        .linearGradient(
            Gradient(colors: [.black.opacity(0.2), .black.opacity(0)]),
            startPoint: .bottom,
            endPoint: .center)
    }
    
    var body: some View {
        VStack {
            Rectangle()
                .overlay {
                    ZStack {
                        Image(blockImg)
                            .resizable()
                            .scaledToFill()
                            //.opacity(0.5)
                        
                        gradient
                        Text(blockName)
                            .font(.system(size: 20, design: .rounded))
                            .fontWeight(.bold)
                            .padding(.bottom, -5)
                            .frame(alignment: .leading)
                            .shadow(color: Color.white.opacity(0.5), radius: 7, x: 0, y: 2)
                    }
                    .scaledToFill()
                }
                .frame(width: 150, height: 120)
                .padding(.bottom, 5)
        
            VStack(alignment:.leading) {
                HStack {
                    Image(systemName:"calendar.circle")
                    Text("2025/01/01")
                        .fontWeight(.semibold)
                        .font(.system(size: 14, design: .rounded))
                }
                HStack {
                    Image(systemName:"book.circle.fill")
                    Text("13/13")
                        .fontWeight(.semibold)
                        .font(.system(size: 14, design: .rounded))
                }
            }
            
            
        }
        .frame(width: 150, height: 180)
        .foregroundStyle(frontColor)
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(color: Color.black.opacity(0.2), radius: 7, x: 0, y: 2)
    }
}

#Preview {
    StampBookView(blockName: "北海道・東北", blockImg: "北海道東北", backgroundColor: .white, frontColor: .black)
}
