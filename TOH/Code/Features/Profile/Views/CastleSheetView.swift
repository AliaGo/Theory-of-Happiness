//
//  CastleSheetView.swift
//  TOH
//
//  Created by Alia on 2025/2/6.
//

import Foundation
import SwiftUI

struct CastleSheet: View {
    
    @StateObject private var viewModel = ProfileViewModel()
    
    var body: some View {
        let columns = [GridItem(), GridItem()]
        VStack {
            Text("My Castle Stamps Collection")
                .font(.title2)
            
            if let userCollectedStamps = viewModel.userCollectedStamps {
                ScrollView(.vertical){
                    LazyVGrid(columns: columns){
                        ForEach(userCollectedStamps, id: \.id) { stamp in
                            VStack{
                                Image(stamp.castleName)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 80, height: 80)
                                    .clipShape(Circle())
                                
                                Text(stamp.castleName)
                                    .font(.subheadline)
                                
                                Text(stamp.collectedDate.formatted())
                                    .font(.footnote)
                            }
                        }
                    }
                }
                
            }
        }
        .task {
            try? await viewModel.getCollectedStamps()
        }
        Spacer()
    }
}
