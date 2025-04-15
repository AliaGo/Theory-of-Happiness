//
//  RamenCellViewBuilder.swift
//  TOH
//
//  Created by Alia on 2025/2/21.
//

import SwiftUI

struct RamenCellViewBuilder: View {
    let ramenId: String
    @State private var ramen: Ramen? = nil
    
    var body: some View {
        ZStack{
            if let ramen {
                FavoriteRamenBlockView(ramen: ramen)
            }
        }
        .task {
            self.ramen = try? await RamenManager.shared.getRamen(ramenId: ramenId)
        }
    }
}

#Preview {
    RamenCellViewBuilder(ramenId: "2")
}
