//
//  ShareManager.swift
//  TOH
//
//  Created by Alia on 2025/10/12.
//
import UIKit

final class ShareManager {
    static let shared = ShareManager()
    private init() {}

    func share(text: String, url: URL) {
        let items: [Any] = [text, url]

        guard let rootVC = UIApplication.shared.connectedScenes
            .compactMap({ ($0 as? UIWindowScene)?.keyWindow?.rootViewController })
            .first else { return }

        
        //完整、iOS系統原生的分享畫面
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        rootVC.present(activityVC, animated: true)
    }
}

