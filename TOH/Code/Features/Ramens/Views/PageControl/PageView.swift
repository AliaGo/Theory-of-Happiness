//
//  PageView.swift
//  TOH
//
//  Created by Alia on 2025/2/19.
//

import SwiftUI

struct PageView<Page: View>: View {
    var pages: [Page]
    @State private var currentPage = 0

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            PageViewController(pages: pages, currentPage: $currentPage)
            PageControl(numberOfPages: pages.count, currentPage: $currentPage)
                .frame(width: CGFloat(pages.count * 18))
                .padding(.trailing)
        }
        .aspectRatio(3 / 2, contentMode: .fit)
    }
}


#Preview {
    PageView(pages: [Ramen(id: 1, name: "ラーメン人生JET", city: "大阪", station: "福島駅", address: "大阪府大阪市福島区福島7-12-2", isFeatured: false, isFavorite: false, year: [2023], rating: 3.77, review: "2919", open: "11:00", url: "https://tabelog.com/osaka/A2701/A270108/27050827/", imageURL: ["https://tblg.k-img.com/restaurant/images/Rvw/113618/150x150_square_113618100.jpg", "https://tblg.k-img.com/restaurant/images/Rvw/113618/150x150_square_113618102.jpg"], category: Ramen.Category.osaka, imageName: "ラーメン人生JET"), Ramen(id: 1, name: "ラーメン人生JET", city: "大阪", station: "福島駅", address: "大阪府大阪市福島区福島7-12-2", isFeatured: false, isFavorite: false, year: [2023], rating: 3.77, review: "2919", open: "11:00", url: "https://tabelog.com/osaka/A2701/A270108/27050827/", imageURL: ["https://tblg.k-img.com/restaurant/images/Rvw/113618/150x150_square_113618100.jpg", "https://tblg.k-img.com/restaurant/images/Rvw/113618/150x150_square_113618102.jpg"], category: Ramen.Category.osaka, imageName: "ラーメン人生JET"), Ramen(id: 1, name: "ラーメン人生JET", city: "大阪", station: "福島駅", address: "大阪府大阪市福島区福島7-12-2", isFeatured: false, isFavorite: false, year: [2023], rating: 3.77, review: "2919", open: "11:00", url: "https://tabelog.com/osaka/A2701/A270108/27050827/", imageURL: ["https://tblg.k-img.com/restaurant/images/Rvw/113618/150x150_square_113618100.jpg", "https://tblg.k-img.com/restaurant/images/Rvw/113618/150x150_square_113618102.jpg"], category: Ramen.Category.osaka, imageName: "ラーメン人生JET"), Ramen(id: 1, name: "ラーメン人生JET", city: "大阪", station: "福島駅", address: "大阪府大阪市福島区福島7-12-2", isFeatured: false, isFavorite: false, year: [2023], rating: 3.77, review: "2919", open: "11:00", url: "https://tabelog.com/osaka/A2701/A270108/27050827/", imageURL: ["https://tblg.k-img.com/restaurant/images/Rvw/113618/150x150_square_113618100.jpg", "https://tblg.k-img.com/restaurant/images/Rvw/113618/150x150_square_113618102.jpg"], category: Ramen.Category.osaka, imageName: "ラーメン人生JET")].map { FeatureCard(ramen: $0) })
}

