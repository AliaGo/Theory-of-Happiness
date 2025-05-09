//
//  PointShopView.swift
//  TOH
//
//  Created by Alia on 2025/5/4.
//

import SwiftUI
import FirebaseFirestore


struct PointShopView: View {
    @StateObject private var viewModel = PointShopViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Text("點數商店")
                    .font(.headline)
                Text("你目前的點數：\(viewModel.userPoints)")
                    .font(.headline)
                    .padding()
                
                Picker("分類", selection: $viewModel.selectedType) {
                        ForEach(ShopItemType.allCases) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding([.horizontal, .bottom])
                
                List(viewModel.filteredItems) { item in
                    HStack(spacing: 10) {
                        if let url = item.imageURL, let imageURL = URL(string: url) {
                            AsyncImage(url: imageURL) { phase in
                                switch phase {
                                case .success(let image): image.resizable().frame(width: 60, height: 60)
                                default: ProgressView()
                                }
                            }
                        }
                        
                        VStack(alignment: .leading) {
                            Text(item.name).font(.headline)
                            Text(item.description).font(.subheadline).foregroundColor(.gray)
                            HStack{
                                Image(systemName: "p.circle.fill")
                                    .foregroundColor(.myGreen2)
                                Text(String(item.cost)).font(.caption)
                            }
                            
                            
                        }
                        .padding(.vertical, 5)
                        
                        Button {
                            viewModel.redeem(item: item)
                        } label: {
                            Text("兌換")
                                .font(.subheadline)
                                .padding(.horizontal)
                                .padding(.vertical, 4)
                                .foregroundColor(.white)
                                .background(Capsule().foregroundColor(.myGreen2))
                        }
                        .disabled(viewModel.userPoints < item.cost)
                        
                    }
                }
                .task {
                    await viewModel.fetchShopItems()
                    // 等會補：也從 UserManager 抓點數
                }
            }
        }
    }
}

#Preview {
    PointShopView()
}
