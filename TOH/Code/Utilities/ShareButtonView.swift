//
//  ShareButtonView.swift
//  TOH
//
//  Created by Alia on 2025/10/12.
//

import SwiftUI

struct ShareButtonView: View {
    let type: String   // 例如 "castle"、"ramen"
    let link: String   // App 內頁的 URL 字串

    var body: some View {
        Button {
            guard let url = URL(string: link) else { return }

            let shareText: String
            switch type {
            case "castle":
                shareText = "快來看更多日本百名城資訊！🏯"
            case "ramen":
                shareText = "跟你分享一家好吃的拉麵店！🍜"
            case "post":
                shareText = "快來看看這篇有趣的貼文！📸"
            default:
                shareText = "和你分享這個好內容！✨"
            }

            ShareManager.shared.share(text: shareText, url: url)
        } label: {
            Image(systemName: "square.and.arrow.up")
                .font(.title3)
                .foregroundColor(.blue)
        }
    }
}

