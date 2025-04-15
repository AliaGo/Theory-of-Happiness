//
//  CategoryItem.swift
//  TOH
//
//  Created by Alia on 2025/2/19.
//

import SwiftUI


struct CategoryItem: View {
    @StateObject private var viewModel = RamenViewModel()
    
    var ramen: Ramen

    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: URL(string: ramen.imageURL[0])) { image in
                image
                    .resizable()
                    .renderingMode(.original)
            } placeholder: {
                Color.black
            }
                .frame(width: 180, height: 150)
                .cornerRadius(5)
                .overlay(alignment: .topTrailing) {
                    Button {
                        viewModel.addUserFavoriteRamen(ramenId: ramen.id)
                    } label: {
                        Capsule()
                            .fill(.white)
                            .frame(width: 30, height: 30)
                            .overlay(alignment: .center) {
                                Label("Toggle Favorite", systemImage: "heart.fill")
                                    .labelStyle(.iconOnly)
                                    .foregroundStyle(.red)
                            }
                        
                            
                    }
                }
            
            
            Text(ramen.name)
                .foregroundStyle(.black)
                .font(.caption)
                
            
            HStack(spacing:5) {
                Image(systemName: "mappin")
                    .foregroundColor(.myGreen2)
                Text(ramen.city)
                    .foregroundStyle(.myGreen2)
                    .font(.caption)
                
                Text(ramen.station)
                    .foregroundStyle(.myGreen2)
                    .font(.caption)
            }
            
        }
        .padding(.leading, 15)
    }
}

#Preview {
    
    return CategoryItem(ramen: Ramen(id: 1, name: "ラーメン人生JET", city: "大阪", station: "福島駅", address: "大阪府大阪市福島区福島7-12-2", isFeatured: false, isFavorite: false, year: [2023], rating: 3.77, review: "2919", open: "11:00", url: "https://tabelog.com/osaka/A2701/A270108/27050827/", imageURL: ["https://tblg.k-img.com/restaurant/images/Rvw/113618/150x150_square_113618100.jpg", "https://tblg.k-img.com/restaurant/images/Rvw/113618/150x150_square_113618102.jpg","https://tblg.k-img.com/restaurant/images/Rvw/113618/150x150_square_113618103.jpg","https://tblg.k-img.com/restaurant/images/Rvw/113618/150x150_square_113618106.jpg","https://tblg.k-img.com/restaurant/images/Rvw/4689/150x150_square_4689386.jpg","https://tblg.k-img.com/restaurant/images/Rvw/4689/150x150_square_4689387.jpg","https://tblg.k-img.com/restaurant/images/Rvw/4689/150x150_square_4689388.jpg","https://tblg.k-img.com/restaurant/images/Rvw/4689/150x150_square_4689389.jpg","https://tblg.k-img.com/restaurant/images/Rvw/4689/150x150_square_4689390.jpg","https://tblg.k-img.com/restaurant/images/Rvw/4689/150x150_square_4689406.jpg","https://tblg.k-img.com/restaurant/images/Rvw/272655/150x150_square_d98d71475cb0a55fffe27e37cdeec163.jpg","https://tblg.k-img.com/restaurant/images/Rvw/272655/150x150_square_93728773cc8cdf502fdfb6bab4f00058.jpg","https://tblg.k-img.com/restaurant/images/Rvw/272655/150x150_square_4fa49f242964af836929ab7c0a6eac6a.jpg","https://tblg.k-img.com/restaurant/images/Rvw/272655/150x150_square_61db505146c37f50be6d3a1fec2f7c63.jpg","https://tblg.k-img.com/restaurant/images/Rvw/271186/150x150_square_dcf8abcc0652f9cccf76b1871c3c1046.jpg","https://tblg.k-img.com/restaurant/images/Rvw/271186/150x150_square_f014e13dee3501cf97f221149217af1c.jpg","https://tblg.k-img.com/restaurant/images/Rvw/270992/150x150_square_9e5bb17e9dddb1c0be3e433d482eb829.jpg","https://tblg.k-img.com/restaurant/images/Rvw/4689/150x150_square_4689364.jpg","https://tblg.k-img.com/restaurant/images/Rvw/4689/150x150_square_4689366.jpg","https://tblg.k-img.com/restaurant/images/Rvw/272655/150x150_square_ffe15ca4f94523c5a7a2e1af2cd34754.jpg"], category: Ramen.Category.osaka, imageName: "ラーメン人生JET"))
}

