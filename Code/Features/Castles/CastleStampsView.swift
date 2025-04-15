//
//  CastleStamps.swift
//  TOH
//
//  Created by Alia on 2025/2/28.
//

import SwiftUI

struct CastleStampsView: View {
    @StateObject private var viewModel = CastleViewModel()
    var area: String
    var mainColor: Color
    
    var body: some View {
        let columns = [GridItem(), GridItem(), GridItem()]
        ScrollView(.vertical) {
            LazyVGrid(columns: columns){
                ForEach(viewModel.castles.filter {i in (i.area == area)}, id: \.id) { c in
                    VStack{
                        Image(String(c.name))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                        RoundedRectangle(cornerRadius: 10)
                            .fill(mainColor)
                            .frame(width:120, height: 25)
                            .overlay {
                                Text(c.name)
                                    .font(.caption)
                                    .foregroundColor(.white)
                            }
                    }
                }
            }
        }
        .task{
            try? await viewModel.getAllCastles()
        }
    }
}

#Preview {
    CastleStampsView(area: "北海道・東北", mainColor: Color.gray)
}
