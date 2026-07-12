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
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        let columns = [GridItem(), GridItem()]
        NavigationStack {
            ScrollView {
                VStack {
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
            }
            .navigationTitle("💮我的城堡印章")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .imageScale(.medium)
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
