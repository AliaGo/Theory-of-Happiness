//
//  GuideView.swift
//  TOH
//
//  Created by Alia on 2025/5/4.
//

import SwiftUI

struct GuideView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("Theory of Happiness")
                        .font(.largeTitle)
                        .bold()
                    
                    Group {
                        Text("🎯 這是什麼 App？")
                            .font(.title2)
                            .bold()
                        Text("這是一款結合日本百名城與拉麵百名店的數位印章收集 App，讓你在旅途中邊走邊蒐集專屬記錄與回憶。")
                    }
                    
                    Group {
                        Text("🏯 百名城印章")
                            .font(.title2)
                            .bold()
                        Text("""
                            - 可以查詢攻城相關的所有資訊。
                            - 當你親自造訪城堡後，上傳現場照片。
                            - App 會透過 GPS 確認是否到訪。
                            - 成功攻城後即可獲得專屬的數位印章。
                            - 每個印章設計皆根據城堡特色與地區配色。
                            """)
                    }
                    
                    Group {
                        Text("🍜 拉麵百名店")
                            .font(.title2)
                            .bold()
                        Text("""
                            - 收錄日本知名餐廳評論網 Tabelog 選出的拉麵百名店（目前僅收錄2024年，會陸續更新）。
                            - 到店後上傳照片，獲得點數！
                            - 和其他使用者分享美味與回憶。
                            """)
                    }

                    Group {
                        Text("🖼 貼文牆與社群")
                            .font(.title2)
                            .bold()
                        Text("""
                            - 上傳你造訪景點的照片與心得。
                            - 查看其他人的分享與旅程。
                            - 互相按讚與留言，一起享受冒險！
                            """)
                    }

                    Group {
                        Text("💡 使用方式")
                            .font(.title2)
                            .bold()
                        Text("""
                            1. 造訪景點（城堡或拉麵店）
                            2. 拍攝現場照片並上傳
                            3. 通過 GPS 驗證後獲得印章
                            4. 到「Profile」>「My Collection」查看已收集印章
                            """)
                    }

                    Group {
                        Text("🔒 數據與隱私")
                            .font(.title2)
                            .bold()
                        Text("你的地理位置僅用於確認是否造訪，照片與資料亦不會外洩。")
                    }

                    Group {
                        Text("📮 聯絡我們")
                            .font(.title2)
                            .bold()
                        Text("使用上有任何問題，或需要回報內容時，歡迎透過以下信箱聯絡我們。")
                        Link("aliaShigeno@gmail.com", destination: URL(string: "mailto:aliaShigeno@gmail.com")!)
                            .font(.body.weight(.semibold))
                    }

                    Spacer(minLength: 20)
                }
                .padding()
            }
            .navigationTitle("使用指南")
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}


#Preview {
    GuideView()
}
