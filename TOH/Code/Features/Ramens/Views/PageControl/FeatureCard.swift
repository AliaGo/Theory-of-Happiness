//
//  FeatureCard.swift
//  TOH
//
//  Created by Alia on 2025/2/19.
//

import SwiftUI


struct FeatureCard: View {
    var ramen: Ramen


    var body: some View {
        AsyncImage(url: URL(string: ramen.imageURL[0])) { image in
            image.resizable()
        } placeholder: {
            Color.black
        }
        .overlay {
            TextOverlay(ramen: ramen)
        }
        
        //之後再把照片加進去
        /*
        ramen.featureImage?
            .resizable()
            .overlay {
                TextOverlay(ramen: ramen)
            }
         */
    }
}

struct TextOverlay: View {
    var ramen: Ramen


    var gradient: LinearGradient {
        .linearGradient(
            Gradient(colors: [.black.opacity(0.6), .black.opacity(0)]),
            startPoint: .bottom,
            endPoint: .center)
    }


    var body: some View {
        ZStack(alignment: .bottomLeading) {
            gradient
            VStack(alignment: .leading) {
                Text(ramen.name)
                    .font(.title)
                    .bold()
                Text(ramen.city)
            }
            .padding()
        }
        .foregroundStyle(.white)
    }
}

#Preview {
    FeatureCard(ramen: Ramen(id: 1, name: "ラーメン人生JET", city: "大阪", station: "福島駅", address: "大阪府大阪市福島区福島7-12-2", isFeatured: false, isFavorite: false, year: [2023], rating: 3.77, review: "2919", open: "11:00", url: "https://tabelog.com/osaka/A2701/A270108/27050827/", imageURL: ["https://tblg.k-img.com/restaurant/images/Rvw/113618/150x150_square_113618100.jpg", "https://tblg.k-img.com/restaurant/images/Rvw/113618/150x150_square_113618102.jpg"], category: Ramen.Category.osaka, imageName: "ラーメン人生JET"))
        .aspectRatio(3 / 2, contentMode: .fit)
}
