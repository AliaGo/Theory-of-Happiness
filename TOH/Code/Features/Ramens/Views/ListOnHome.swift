//
//  ListOnHome.swift
//  TOH
//
//  Created by Alia on 2025/5/6.
//

import SwiftUI

struct ListRamenOnHome: View {
    var isWhere: Bool
    var list: [Ramen]
    
    
    var body: some View {
        let rows = [GridItem()]
        if isWhere{
            LazyHGrid(rows: rows, spacing: 20) {
                ForEach(list) { item in
                    NavigationLink{
                        RamenInfoView(ramen: item)
                    } label: {
                        RamenSingleView(ramen: item).padding(.bottom, 3)
                    }
                }
            }.padding(.leading, 30)
        }
    }
}

struct ListTWRamenOnHome: View {
    var isWhere: Bool
    var list: [TWRamen]
    
    
    var body: some View {
        let rows = [GridItem()]
        if isWhere{
            LazyHGrid(rows: rows, spacing: 20) {
                ForEach(list) { item in
                    NavigationLink{
                        TWRamenInfoView(ramen: item)
                    } label: {
                        TWRamenSingleView(ramen: item).padding(.bottom, 3)
                    }
                }
            }.padding(.leading, 30)
        }
    }
}

