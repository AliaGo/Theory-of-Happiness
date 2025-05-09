//
//  CategoryRow.swift
//  TOH
//
//  Created by Alia on 2025/2/19.
//

import SwiftUI


struct CategoryRow: View {
    
    
    var categoryName: String
    var items: [Ramen]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(categoryName)
                .font(.headline)
                .padding(.leading, 15)
                .padding(.top, 5)
            
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 0) {
                    ForEach(items) { ramen in
                        
                        NavigationLink {
                            RamenInfoView(ramen: ramen)
                        } label: {
                            CategoryItem(ramen: ramen)
                                
                        }
                        
                         
                    }
                }
            }
            .frame(height: 185)
        }
    }
}

/*
#Preview {
    let ramens = ModelData().ramens
    return CategoryRow(
        categoryName: ramens[0].category.rawValue,
        items: Array(ramens.prefix(4))
    )
}
*/
