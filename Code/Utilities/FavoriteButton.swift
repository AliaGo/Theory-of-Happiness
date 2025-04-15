//
//  FavoriteButton.swift
//  TOH
//
//  Created by Alia on 2025/2/17.
//

import SwiftUI


struct FavoriteButton: View {
    @Binding var isSet: Bool
    
    var body: some View {
        Button {
            isSet.toggle()
        } label: {
            Label("Toggle Favorite", systemImage: isSet ? "heart.fill" : "heart")
                .labelStyle(.iconOnly)
                .foregroundStyle(isSet ? .red : .gray)
        }
    }
}


#Preview {
    FavoriteButton(isSet: .constant(true))
}
