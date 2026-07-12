//
//  StatsCard.swift
//  TOH
//
//  Created by Alia on 2026/2/8.
//
import SwiftUI

struct StatCard: View {
    let icon: String
    let title: String
    let value: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title3)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.gray)

                Text(value)
                    .font(.largeTitle)
                    .bold()
            }
        }
        .padding()
        .frame(width: 170, height: 70)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 6)
    }
}
