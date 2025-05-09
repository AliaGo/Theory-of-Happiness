//
//  TWRamenCellViewBuilder.swift
//  TOH
//
//  Created by Alia on 2025/5/7.
//

import SwiftUI

struct TWRamenCellViewBuilder: View {
    let ramenId: String
    @State private var ramen: TWRamen? = nil
    
    var body: some View {
        ZStack{
            if let ramen {
                FavoriteTWRamenBlockView(ramen: ramen)
            }
        }
        .task {
            self.ramen = try? await TWRamenManager.shared.getTWRamen(ramenId: ramenId)
        }
    }
}

