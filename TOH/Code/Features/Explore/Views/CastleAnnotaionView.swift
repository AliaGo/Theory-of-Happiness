//
//  AnnotaionView.swift
//  TOH
//
//  Created by Alia on 2025/5/7.
//

import SwiftUI
import MapKit


struct CastleAnnotationView: View {
    let castle: Castle
    var onTap: () -> Void

    var body: some View {
        AsyncImage(url: URL(string: castle.imageURL[0])) { image in
            image.resizable()
        } placeholder: {
            Color.black
        }
        .frame(maxWidth: 40, maxHeight: 40)
        .clipShape(Circle())
        .overlay {
            Circle().stroke(.black, lineWidth: 2)
        }
        .onTapGesture {
            onTap()
        }
    }
}

