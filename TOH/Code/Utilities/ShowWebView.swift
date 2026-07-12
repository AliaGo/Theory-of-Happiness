//
//  ShowWebView.swift
//  TOH
//
//  Created by Alia on 2025/10/10.
//

import SwiftUI
import WebKit

struct ShowWebView: UIViewRepresentable {
    let url: URL?

    func makeUIView(context: Context) -> WKWebView {
        WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let safeUrl = url {
            let request = URLRequest(url: safeUrl)
            uiView.load(request)
        }
    }
}

struct FullScreenWebView: View {
    let url: URL
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ShowWebView(url: url)
                .ignoresSafeArea()
                .navigationTitle("詳細內容")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Label("返回", systemImage: "chevron.left")
                        }
                    }
                }
        }
    }
}
