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
                        if viewModel.collectedStampIds.contains(c.id) {
                                // 顯示有收集到的印章圖片
                            Image(String(c.name))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                            } else {
                                // 顯示空心圈圈（placeholder）
                                Circle()
                                    .stroke(Color.gray, lineWidth: 2)
                                    .frame(width: 100, height: 100)
                            }
                        /*
                        Image(String(c.name))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                        
                        
                        Circle()
                            .stroke(Color.gray, lineWidth: 2)
                            .frame(width: 100, height: 100)
                         */
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
            //New
            try? await viewModel.loadCollectedStamps()
        }
    }
}

#Preview {
    CastleStampsView(area: "北海道・東北", mainColor: Color.gray)
}
