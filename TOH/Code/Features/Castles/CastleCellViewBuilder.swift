//
//  CastleCellViewBuilder.swift
//  TOH
//
//  Created by Alia on 2025/2/20.
//

import SwiftUI

struct CastleCellViewBuilder: View {
    
    let castleId: String
    @State private var castle: Castle? = nil
    
    var body: some View {
        ZStack{
            if let castle {
                FavoriteCastleBlockView(castle: castle)
            }
        }
        .task {
            self.castle = try? await CastleManager.shared.getCastle(castleId: castleId)
        }
    }
}

#Preview {
    CastleCellViewBuilder(castleId: "1")
}
