//
//  ShortcutView.swift
//  TOH
//
//  Created by Alia on 2026/2/8.
//
import SwiftUI


struct ShortcutGridView: View {
    @Binding var showPhotoSheet: Bool
    @Binding var showRamenSheet: Bool
    @Binding var showCastleSheet: Bool
    
    let user: DBUser?

    var body: some View {
        HStack(spacing: 12) {
            ShortcutButton(title: "攻城日記", icon: "Samurai") {
                showPhotoSheet = true
            }
            .fullScreenCover(isPresented: $showPhotoSheet) {
                PhotoWallCastleView(userId: user?.userId ?? "")
            }
            
            ShortcutButton(title: "拉麵日記", icon: "ramen") {
                showRamenSheet = true
            }
            .fullScreenCover(isPresented: $showRamenSheet) {
                PhotoWallRamenView(userId: user?.userId ?? "")
            }
            
            ShortcutButton(title: "我的攻城簿", icon: "castle") {
                showCastleSheet = true
            }
            .fullScreenCover(isPresented: $showCastleSheet) {
                CastleSheet()
            }
            
            
            //ShortcutButton(title: "Point Shop", icon: "cart") {}
        }
        .padding(.horizontal)
    }
}


struct ShortcutButton: View {
    let title: String
    let icon: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)

                Text(title)
                    .font(.caption)
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 72)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color("MyGreen1"))
            )
        }
        .buttonStyle(.plain)
    }
}

