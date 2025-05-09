//
//  TaiwanRamenListView.swift
//  TOH
//
//  Created by Alia on 2025/5/6.
//

import SwiftUI

enum GroupingType: String, CaseIterable, Identifiable {
    case mrtLine = "捷運線"
    case city = "行政區"
    
    var id: String { self.rawValue }
}

struct TWRamenListView: View {
    
    @StateObject private var viewModel = TWRamenViewModel()
    let ramens: [TWRamen]
    @State private var searchText = ""
    @State private var grouping: GroupingType = .mrtLine
    
    var filteredRamens: [TWRamen] {
        if searchText.isEmpty {
            return ramens
        } else {
            return ramens.filter {
                //之後再新增一些
                $0.name.localizedStandardContains(searchText) ||
                $0.city.localizedStandardContains(searchText) ||
                $0.mrt.localizedStandardContains(searchText) ||
                $0.reviewsTags.contains { item in item.localizedStandardContains(searchText) }
                
            }
        }
    }
    
    // 以MRT或區域做分群
    var groupedRamens: [String: [TWRamen]] {
        switch grouping {
        case .mrtLine:
            var grouped: [String: [TWRamen]] = [:]
            for ramen in filteredRamens {
                for line in ramen.mrtLine {
                    grouped[line, default: []].append(ramen)
                }
            }
            return grouped
        case .city:
            return Dictionary(grouping: filteredRamens, by: { $0.city })
        }
    }

    
    var body: some View {
        VStack {
            Picker("分組依據", selection: $grouping) {
                ForEach(GroupingType.allCases) { type in
                    Text(type.rawValue).tag(type)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            .padding(.top)
            
            List {
                ForEach(groupedRamens.keys.sorted(), id: \.self) { key in
                    TWCategoryRow(categoryName: key, items: groupedRamens[key]!)
                }
                .listRowInsets(EdgeInsets())
            }
            .listStyle(.inset)
        }
        .navigationTitle("Taipei Ramen")
        .searchable(text: $searchText, prompt: "請輸入拉麵種類、車站等")
    }
}

