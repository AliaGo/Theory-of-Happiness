//
//  RamenAnnotationView.swift
//  TOH
//
//  Created by Alia on 2025/5/7.
//

import SwiftUI
import MapKit



struct RamenAnnotationView: View {
    let ramen: TWRamen
    var onTap: () -> Void

    var body: some View {
        AsyncImage(url: URL(string: ramen.reviewImageUrls?.first ?? "")) { image in
            image.resizable()
        } placeholder: {
            Color.purple
        }
        .frame(maxWidth: 40, maxHeight: 40)
        .clipShape(Circle())
        .overlay {
            Circle().stroke(.purple, lineWidth: 2)
        }
        .onTapGesture {
            onTap()
        }
    }
}

