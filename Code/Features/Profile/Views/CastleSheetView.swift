//
//  CastleSheetView.swift
//  TOH
//
//  Created by Alia on 2025/2/6.
//

import Foundation
import SwiftUI

struct CastleSheet: View {
    
    var body: some View {
        VStack {
            Text("My Castle Stamps Collection")
                .font(.title2)
            
            HStack{
                VStack {
                    Image("五稜郭")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    
                    Text("2 五稜郭")
                        .font(.subheadline)
                }
                
                VStack {
                    Image("五稜郭")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    
                    Text("2 五稜郭")
                        .font(.subheadline)
                }
                
                VStack {
                    Image("五稜郭")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    
                    Text("2 五稜郭")
                        .font(.subheadline)
                }
            }
        }
        Spacer()
    }
}
