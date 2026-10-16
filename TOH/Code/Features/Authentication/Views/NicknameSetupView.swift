//
//  NicknameSetupView.swift
//  TOH
//

import SwiftUI

struct SamuraiClan: Identifiable, Hashable {
    let id: String
    let name: String
    let kamonName: String
    let motto: String

    static let all: [SamuraiClan] = [
        .init(id: "akechi", name: "明智氏", kamonName: "kamon_akechi", motto: "以智略開路"),
        .init(id: "chosokabe", name: "長宗我部氏", kamonName: "kamon_chosokabe", motto: "制霸四國之志"),
        .init(id: "date", name: "伊達氏", kamonName: "kamon_Date", motto: "獨眼之志，勇往直前"),
        .init(id: "mouri", name: "毛利氏", kamonName: "kamon_mouli", motto: "三箭齊心，無往不利"),
        .init(id: "oda", name: "織田氏", kamonName: "kamon_oda", motto: "以革新開創天下"),
        .init(id: "sanada", name: "真田氏", kamonName: "kamon_sanada", motto: "赤備之魂，百折不撓"),
        .init(id: "takeda", name: "武田氏", kamonName: "kamon_takedabishi", motto: "風林火山，兵貴神速"),
        .init(id: "tokugawa", name: "德川氏", kamonName: "kamon_tokugawa", motto: "厚積而後制天下"),
        .init(id: "toyotomi", name: "豐臣氏", kamonName: "kamon_toyotomi", motto: "以夢想築起大坂"),
        .init(id: "uesugi", name: "上杉氏", kamonName: "kamon_uesuki", motto: "毘沙門天，義在心中")
    ]
}

struct NicknameSetupView: View {
    @StateObject private var viewModel = AuthenticationViewModel()
    @State private var page = 0
    @State private var nickname = ""
    @State private var selectedClan = SamuraiClan.all[0]
    @State private var errorMessage: String?
    @State private var isSubmitting = false

    let onComplete: (String) -> Void

    var body: some View {
        ZStack {
            Color(red: 0.94, green: 0.92, blue: 0.84).ignoresSafeArea()

            VStack(spacing: 0) {
                TabView(selection: $page) {
                    storyPage(
                        emblem: "building.2.crop.circle",
                        title: "戰國之門，已為你開啟",
                        description: "從日本百名城出發，收藏旅程、攻下城池，寫下屬於你的攻城簿。",
                        accent: Color("MyGreen1")
                    )
                    .tag(0)

                    storyPage(
                        emblem: "takeoutbag.and.cup.and.straw.fill",
                        title: "行軍路上，也別錯過一碗拉麵",
                        description: "探索名店、記錄味道。每一次遠征，都值得有一碗好拉麵相伴。",
                        accent: .orange
                    )
                    .tag(1)

                    allegiancePage
                        .tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .always))

                Button(action: advance) {
                    HStack(spacing: 8) {
                        if isSubmitting { ProgressView().tint(.white) }
                        Text(page == 2 ? "受封為武士" : "繼續")
                        if page < 2 { Image(systemName: "arrow.right") }
                    }
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(Color("MyGreen1"), in: RoundedRectangle(cornerRadius: 16))
                }
                .disabled(isSubmitting)
                .padding(.horizontal, 24)
                .padding(.bottom, 28)
            }
        }
    }

    private func storyPage(emblem: String, title: String, description: String, accent: Color) -> some View {
        VStack(spacing: 24) {
            Image(systemName: emblem)
                .font(.system(size: 76, weight: .medium))
                .foregroundStyle(accent)
                .frame(width: 150, height: 150)
                .background(.white.opacity(0.72), in: Circle())

            Text(title)
                .font(.title.bold())
                .multilineTextAlignment(.center)

            Text(description)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .lineSpacing(5)
                .padding(.horizontal, 34)
        }
        .padding(.bottom, 34)
    }

    private var allegiancePage: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 14) {
                Text("選擇你的主君")
                    .font(.title.bold())
                Text("從今日起，你將以家紋為名，踏上攻城之路。")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)

                TextField("為自己取一個武士名", text: $nickname)
                    .textInputAutocapitalization(.never)
                    .padding(14)
                    .background(.white, in: RoundedRectangle(cornerRadius: 14))
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(errorMessage == nil ? .clear : .red, lineWidth: 1))
                    .padding(.horizontal, 24)

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                    ForEach(SamuraiClan.all) { clan in
                        Button {
                            selectedClan = clan
                        } label: {
                            VStack(spacing: 5) {
                                Image(clan.kamonName)
                                    .resizable()
                                    .renderingMode(.template)
                                    .scaledToFit()
                                    .foregroundStyle(Color("MyGreen1"))
                                    .frame(width: 40, height: 40)
                                Text(clan.name).font(.subheadline.bold())
                                Text(clan.motto).font(.caption2).foregroundStyle(.secondary).lineLimit(1)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(.white.opacity(0.8), in: RoundedRectangle(cornerRadius: 14))
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(selectedClan == clan ? Color("MyGreen1") : .clear, lineWidth: 2)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 24)

                Label("獲得家紋：\(selectedClan.name)", systemImage: "seal.fill")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Color("MyGreen1"))

                if let errorMessage {
                    Text(errorMessage).font(.caption).foregroundStyle(.red)
                }
            }
            .padding(.top, 18)
            .padding(.bottom, 18)
        }
    }

    private func advance() {
        guard page < 2 else {
            let trimmedName = nickname.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmedName.isEmpty else {
                errorMessage = "請先填寫你的武士名"
                return
            }
            isSubmitting = true
            Task {
                do {
                    try await viewModel.completeWarriorOnboarding(nickname: trimmedName, clan: selectedClan)
                    onComplete(trimmedName)
                } catch {
                    errorMessage = "授封失敗，請確認網路後再試一次。"
                }
                isSubmitting = false
            }
            return
        }
        withAnimation { page += 1 }
    }
}

#Preview {
    NicknameSetupView { _ in }
}
