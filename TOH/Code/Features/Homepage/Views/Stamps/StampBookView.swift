//
//  StampBookView.swift
//  TOH
//
//  Created by Alia on 2025/2/28.
//

import SwiftUI

struct StampBookView: View {
    var blockImg: String
    var backgroundColor: Color
    var frontColor: Color
    var num: Int
    
    
    var gradient: LinearGradient {
        .linearGradient(
            Gradient(colors: [.black.opacity(0.2), .black.opacity(0)]),
            startPoint: .bottom,
            endPoint: .center)
    }
    
    var body: some View {
        VStack{
            Rectangle()
                .overlay {
                    Image(blockImg)
                        .resizable()
                        .scaledToFill()
                }
                .frame(width: 150, height: 150)
                .padding(.bottom, 5)
            
            VStack(alignment:.leading) {
                /*
                HStack {
                    Image(systemName:"calendar.circle")
                    Text("2025/01/01")
                        .fontWeight(.semibold)
                        .font(.system(size: 14, design: .rounded))
                }
                */
                HStack {
                    Image(systemName:"book.circle.fill")
                    Text("共 \(String(num)) 個")
                        .fontWeight(.semibold)
                        .font(.system(size: 14, design: .rounded))
                }
            }
            Spacer()
        }
        .frame(width: 150, height: 200)
        .foregroundStyle(frontColor)
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(color: Color.black.opacity(0.2), radius: 7, x: 0, y: 2)
        .padding(.bottom, 3)
    }
}

#Preview {
    StampBookView(blockImg: "北海道東北", backgroundColor: .white, frontColor: .black, num: 14)
}
