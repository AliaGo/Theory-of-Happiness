//
//  CastleSheetView.swift
//  TOH
//
//  Created by Alia on 2025/2/6.
//

import Foundation
import SwiftUI

struct CastleSheet: View {

    @StateObject private var viewModel = ProfileViewModel()
    @Environment(\.dismiss) private var dismiss

    private var collectedStamps: [UserCollectedStamps] {
        viewModel.userCollectedStamps ?? []
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack(alignment: .firstTextBaseline) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("日本百名城")
                                .font(.headline)
                            Text("已攻下 \(viewModel.castleVisits.count) / 100 座")
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Text("\(viewModel.castleVisits.count)%")
                            .font(.title2.bold())
                            .foregroundStyle(Color("MyGreen1"))
                    }
                }
                .listRowBackground(Color("MyGreen1").opacity(0.12))

                Section {
                    NavigationLink {
                        CollectedStampBookView()
                    } label: {
                        HStack(spacing: 14) {
                            Image(systemName: "seal.fill")
                                .font(.title2)
                                .foregroundStyle(.white)
                                .frame(width: 46, height: 46)
                                .background(Color("MyGreen1"), in: RoundedRectangle(cornerRadius: 14))

                            VStack(alignment: .leading, spacing: 4) {
                                Text("我的集章冊")
                                    .font(.headline)
                                Text("上傳現場貼文獲得的城堡印章")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()

                            Text("\(collectedStamps.count) 枚")
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(Color("MyGreen1"))
                        }
                        .padding(.vertical, 5)
                    }
                }

                Section("已攻下") {
                    if viewModel.castleVisits.isEmpty {
                        ContentUnavailableView(
                            "還沒有攻城紀錄",
                            systemImage: "checkmark.seal",
                            description: Text("在城堡詳情頁按下「我攻下了」即可記錄。")
                        )
                    } else {
                        ForEach(viewModel.castleVisits) { visit in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(visit.castleName)
                                    .font(.headline)
                                HStack {
                                    Label(visit.visitType.displayName, systemImage: "building.columns")
                                    Spacer()
                                    Text(visit.visitedDate.formatted(date: .abbreviated, time: .omitted))
                                }
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 3)
                        }
                    }
                }
            }
            .navigationTitle("我的攻城簿")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .imageScale(.medium)
                    }
                }
            }
        }
        .task {
            await viewModel.loadCastleVisits()
            await viewModel.getCollectedStamps()
        }
    }
}

private struct CollectedStampBookView: View {
    @StateObject private var viewModel = ProfileViewModel()

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 3)

    private var stamps: [UserCollectedStamps] {
        (viewModel.userCollectedStamps ?? []).sorted { $0.collectedDate > $1.collectedDate }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                HStack(spacing: 12) {
                    Image(systemName: "seal.fill")
                        .font(.title2)
                        .foregroundStyle(.white)
                        .frame(width: 48, height: 48)
                        .background(Color("MyGreen1"), in: RoundedRectangle(cornerRadius: 15))

                    VStack(alignment: .leading, spacing: 3) {
                        Text("我的集章冊")
                            .font(.title3.bold())
                        Text("\(stamps.count) / 100 枚城堡印章")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color("MyGreen1").opacity(0.11), in: RoundedRectangle(cornerRadius: 20))

                if stamps.isEmpty {
                    ContentUnavailableView(
                        "集章冊還是空的",
                        systemImage: "seal",
                        description: Text("在城堡附近上傳含 GPS 的現場貼文，成功驗證後即可獲得印章。")
                    )
                    .frame(maxWidth: .infinity, minHeight: 300)
                } else {
                    LazyVGrid(columns: columns, spacing: 14) {
                        ForEach(stamps, id: \.id) { stamp in
                            StampCard(stamp: stamp)
                        }
                    }
                }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("我的集章冊")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.getCollectedStamps()
        }
    }
}

private struct StampCard: View {
    let stamp: UserCollectedStamps

    private var stampAssetName: String {
        let alternativeNames = [
            "姫路城": "姬路城",
            "赤穂城": "赤穗城",
            "広島城": "廣島城",
            "岩国城": "岩國城",
            "大分府内城": "大分府內城",
            "今帰仁城": "今歸仁城"
        ]
        return alternativeNames[stamp.castleName] ?? stamp.castleName
    }

    var body: some View {
        VStack(spacing: 8) {
            Image(stampAssetName)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .frame(height: 92)
                .padding(7)
                .background(Color.white.opacity(0.92), in: RoundedRectangle(cornerRadius: 12))

            Text(stamp.castleName)
                .font(.caption.weight(.bold))
                .foregroundStyle(.primary)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(minHeight: 31)

            Text("取得 \(stamp.collectedDate.formatted(date: .abbreviated, time: .omitted))")
                .font(.caption2)
                .foregroundStyle(.secondary)
                .lineLimit(1)
        }
        .padding(8)
        .frame(maxWidth: .infinity, alignment: .top)
        .background(
            LinearGradient(
                colors: [Color.white, Color("MyGreen1").opacity(0.08)],
                startPoint: .top,
                endPoint: .bottom
            ),
            in: RoundedRectangle(cornerRadius: 16)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color("MyGreen1").opacity(0.18), lineWidth: 1)
        }
        .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
    }
}
