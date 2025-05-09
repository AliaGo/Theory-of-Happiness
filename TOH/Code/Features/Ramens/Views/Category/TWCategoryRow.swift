//
//  TWCategoryRow.swift
//  TOH
//
//  Created by Alia on 2025/5/7.
//

import SwiftUI

struct TWCategoryRow: View {
    
    var categoryName: String
    var items: [TWRamen]
    
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
                            TWRamenInfoView(ramen: ramen)
                        } label: {
                            TWCategoryItem(ramen: ramen)
                                
                        }
                        
                         
                    }
                }
            }
            .frame(height: 185)
        }
    }
}

