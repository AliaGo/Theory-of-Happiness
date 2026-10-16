//
//  CastleInfo_v2.swift
//  TOH
//
//  新版城堡資訊頁：保留舊 CastleInfoView，供設計確認使用。
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI

/// 正式城堡資訊頁。保留檔案名稱 v2，方便追溯本次版型改版。
struct CastleInfoView: View {
    private enum Tab: String, CaseIterable, Identifiable {
        case overview = "總覽"
        case route = "探索路線"
        case history = "歷史來由"

        var id: Self { self }
    }

    let castle: Castle
    let isCanvasPreview: Bool
    @StateObject private var viewModel = CastleViewModel()
    @State private var selectedTab: Tab = .overview
    @State private var showVisitSheet = false
    @State private var showGallery = false
    @State private var selectedImageIndex = 0

    private let parchment = Color(red: 0.96, green: 0.93, blue: 0.86)
    private let ink = Color(red: 0.17, green: 0.25, blue: 0.20)
    private let moss = Color(red: 0.16, green: 0.42, blue: 0.34)

    init(castle: Castle, isCanvasPreview: Bool = false) {
        self.castle = castle
        self.isCanvasPreview = isCanvasPreview
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                hero
                tabPicker

                Group {
                    switch selectedTab {
                    case .overview: overview
                    case .route: route
                    case .history: history
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 22)
                .padding(.bottom, 36)
            }
        }
        .background(Color(red: 0.99, green: 0.98, blue: 0.95))
        .navigationTitle(castle.name)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showVisitSheet) {
            CastleInfoV2VisitSheet(castle: castle, viewModel: viewModel)
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
        .fullScreenCover(isPresented: $showGallery) {
            FullscreenImageViewer(urls: castle.imageURL, selectedIndex: selectedImageIndex)
        }
        .task {
            guard !isCanvasPreview else { return }
            try? await viewModel.checkUserFavoriteCastle(castleId: castle.id)
            await viewModel.loadVisitStatus(castleId: castle.id)
            await viewModel.loadCommunityStats(castleId: castle.id)
        }
    }

    private var hero: some View {
        ZStack(alignment: .bottomLeading) {
            if isCanvasPreview {
                Color(red: 0.70, green: 0.78, blue: 0.69)
                    .overlay {
                        Image(systemName: "building.columns.fill")
                            .font(.system(size: 72))
                            .foregroundStyle(.white.opacity(0.75))
                    }
            } else if let url = castle.imageURL.first {
                ZStack {
                    // 以同張照片填滿背景，前景保留完整比例，避免直幅或特殊比例的照片被裁切。
                    WebImage(url: URL(string: url), options: [.retryFailed, .scaleDownLargeImages]) { image in
                        image.resizable().scaledToFill()
                    } placeholder: {
                        Color.gray.opacity(0.25)
                    }
                    .blur(radius: 16)
                    .scaleEffect(1.08)
                    .opacity(0.55)

                    WebImage(url: URL(string: url), options: [.retryFailed, .scaleDownLargeImages]) { image in
                        image.resizable().scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                    .indicator(.activity)
                    .padding(.vertical, 4)
                }
                .frame(height: 300)
                .frame(maxWidth: .infinity)
                .clipped()
            } else {
                Color.gray.opacity(0.25).frame(height: 300)
            }

            LinearGradient(colors: [.clear, .black.opacity(0.72)], startPoint: .center, endPoint: .bottom)
                .frame(height: 300)

            VStack(alignment: .leading, spacing: 6) {
                Text(castle.name)
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                Label(castle.city, systemImage: "mappin.and.ellipse")
                    .font(.subheadline.weight(.semibold))
            }
            .foregroundStyle(.white)
            .padding(22)

            Button {
                showVisitSheet = true
            } label: {
                Label(viewModel.hasVisited ? "已攻下" : "我攻下了", systemImage: viewModel.hasVisited ? "checkmark.seal.fill" : "flag.fill")
                    .font(.subheadline.bold())
                    .foregroundStyle(viewModel.hasVisited ? moss : Color.orange)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(.ultraThinMaterial, in: Capsule())
            }
            .padding(18)
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .frame(height: 300)
    }

    private var tabPicker: some View {
        HStack(spacing: 0) {
            ForEach(Tab.allCases) { tab in
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) { selectedTab = tab }
                } label: {
                    VStack(spacing: 10) {
                        Text(tab.rawValue).font(.subheadline.bold())
                        Capsule().fill(selectedTab == tab ? moss : .clear).frame(height: 2)
                    }
                    .foregroundStyle(selectedTab == tab ? moss : .secondary)
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 12)
        .padding(.top, 16)
        .background(.background)
    }

    private var overview: some View {
        VStack(alignment: .leading, spacing: 18) {
            sectionTitle("攻城紀錄", icon: "shield.lefthalf.filled")
            HStack(spacing: 12) {
                overviewMetric(value: "\(viewModel.communityStats.visitCount)", label: "勇者攻下", icon: "person.2.fill")
                overviewMetric(value: viewModel.communityStats.recommendationAverage.map { String(format: "%.1f", $0) } ?? "—", label: "推薦指數", icon: "star.fill")
                overviewMetric(value: viewModel.communityStats.difficultyAverage.map { String(format: "%.1f", $0) } ?? "—", label: "攻城難度", icon: "figure.hiking")
            }

            archiveCard
            castlePhotos
        }
    }

    private var archiveCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionTitle("城郭檔案", icon: "scroll.fill")
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                archiveItem("calendar", "築城年代", castle.constructionPeriod ?? "暫無資料")
                archiveItem("mountain.2.fill", "城址類型", castle.castleType ?? "暫無資料")
                archiveItem("person.fill", "築城者", castle.builder ?? "暫無資料")
                archiveItem("crown.fill", "主要城主", castle.mainLords ?? "暫無資料")
            }
        }
        .padding(18)
        .background(parchment, in: RoundedRectangle(cornerRadius: 20))
    }

    private var castlePhotos: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionTitle("城堡照片", icon: "photo.on.rectangle")
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 10) {
                    ForEach(Array(castle.imageURL.enumerated()), id: \.offset) { index, url in
                        Group {
                            if isCanvasPreview {
                                Color(red: 0.78, green: 0.72, blue: 0.62)
                                    .overlay { Image(systemName: "photo").foregroundStyle(.white) }
                            } else {
                                WebImage(url: URL(string: url), options: [.retryFailed, .scaleDownLargeImages]) { image in
                                    image.resizable().scaledToFill()
                                } placeholder: {
                                    Color.gray.opacity(0.16).overlay { ProgressView().controlSize(.mini) }
                                }
                            }
                        }
                        .frame(width: 150, height: 106)
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .onTapGesture {
                            selectedImageIndex = index
                            showGallery = true
                        }
                    }
                }
            }
        }
    }

    private var route: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionTitle("探索路線", icon: "map.fill")
            VStack(alignment: .leading, spacing: 10) {
                Label(castle.address, systemImage: "mappin.circle.fill")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(ink)
                Divider()
                Text(castle.access)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(18)
            .background(parchment, in: RoundedRectangle(cornerRadius: 20))

            MapView(coordinate: castle.locationCoordinate, markerName: castle.name)
                .frame(height: 230)
                .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }

    private var history: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionTitle("歷史來由", icon: "book.closed.fill")
            Text(castle.description)
                .font(.body)
                .foregroundStyle(ink.opacity(0.85))
                .lineSpacing(6)
                .fixedSize(horizontal: false, vertical: true)
                .padding(20)
                .background(parchment, in: RoundedRectangle(cornerRadius: 20))

            if let url = URL(string: castle.url) {
                Link(destination: url) {
                    Label("查看官方／延伸資料", systemImage: "safari")
                        .font(.subheadline.bold())
                        .foregroundStyle(moss)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
    }

    private func sectionTitle(_ title: String, icon: String) -> some View {
        Label(title, systemImage: icon)
            .font(.title3.bold())
            .foregroundStyle(ink)
    }

    private func overviewMetric(value: String, label: String, icon: String) -> some View {
        VStack(spacing: 7) {
            Image(systemName: icon).foregroundStyle(moss)
            Text(value).font(.subheadline.bold()).lineLimit(1).minimumScaleFactor(0.7)
            Text(label).font(.caption2).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(parchment, lineWidth: 1))
    }

    private func archiveItem(_ icon: String, _ label: String, _ value: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: icon).foregroundStyle(moss)
            Text(label).font(.caption).foregroundStyle(.secondary)
            Text(value).font(.subheadline.weight(.semibold)).foregroundStyle(ink).lineLimit(3)
        }
        .frame(maxWidth: .infinity, minHeight: 105, alignment: .topLeading)
        .padding(14)
        .background(Color.white.opacity(0.78), in: RoundedRectangle(cornerRadius: 16))
    }
}

private struct CastleInfoV2VisitSheet: View {
    let castle: Castle
    @ObservedObject var viewModel: CastleViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var visitedDate: Date
    @State private var visitType: CastleVisitType
    @State private var recommendation: Int
    @State private var difficulty: Int
    @State private var note: String
    @State private var showDelete = false

    init(castle: Castle, viewModel: CastleViewModel) {
        self.castle = castle
        _viewModel = ObservedObject(wrappedValue: viewModel)

        let visit = viewModel.visit
        _visitedDate = State(initialValue: visit?.visitedDate ?? .now)
        let normalizedVisitType: CastleVisitType
        switch visit?.visitType {
        case .entered: normalizedVisitType = .fullConquest
        case .outsideOnly: normalizedVisitType = .stampOnly
        case .some(let value): normalizedVisitType = value
        case nil: normalizedVisitType = .fullConquest
        }
        _visitType = State(initialValue: normalizedVisitType)
        _recommendation = State(initialValue: visit?.recommendationRating ?? 5)
        _difficulty = State(initialValue: visit?.difficultyRating ?? 3)
        _note = State(initialValue: visit?.note ?? "")
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    VStack(spacing: 8) {
                        Image(systemName: "shield.lefthalf.filled")
                            .font(.system(size: 32))
                            .foregroundStyle(Color("MyGreen1"))
                        Text(viewModel.visit == nil ? "記錄你的首次攻城" : "更新你的攻城戰報")
                            .font(.headline)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                }

                Section("攻城資料") {
                    DatePicker("造訪日期", selection: $visitedDate, displayedComponents: .date)
                    Picker("攻城完成度", selection: $visitType) {
                        Text("僅蓋章").tag(CastleVisitType.stampOnly)
                        Text("付費參觀").tag(CastleVisitType.paidEntry)
                        Text("全攻略").tag(CastleVisitType.fullConquest)
                    }
                }

                Section("勇者評價") {
                    CastleInfoV2StarRating(title: "推薦指數", rating: $recommendation)
                    CastleInfoV2StarRating(title: "攻城難度", rating: $difficulty)
                }

                Section("攻城心得（選填）") {
                    TextField("這座城最值得記住的是…", text: $note, axis: .vertical)
                        .lineLimit(3...6)
                }

                if viewModel.visit != nil {
                    Section {
                        Button("移除攻城紀錄", role: .destructive) {
                            showDelete = true
                        }
                    }
                }
            }
            .navigationTitle(castle.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("取消") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("儲存") {
                        viewModel.saveVisit(castle: castle, visitedDate: visitedDate, visitType: visitType, recommendationRating: recommendation, difficultyRating: difficulty, note: note)
                        dismiss()
                    }
                }
            }
            .confirmationDialog("移除這筆攻城紀錄？", isPresented: $showDelete) {
                Button("移除", role: .destructive) {
                    viewModel.removeVisit(castleId: castle.id)
                    dismiss()
                }
            }
        }
    }
}

private struct CastleInfoV2StarRating: View {
    let title: String
    @Binding var rating: Int

    var body: some View {
        HStack {
            Text(title)
            Spacer()
            ForEach(1...5, id: \.self) { value in
                Button {
                    rating = value
                } label: {
                    Image(systemName: value <= rating ? "star.fill" : "star")
                        .foregroundStyle(value <= rating ? .orange : .gray)
                }
                .buttonStyle(.plain)
            }
        }
    }
}

#Preview("弘前城") {
    NavigationStack {
        CastleInfoView(castle: CastleInfoV2PreviewData.hirosaki, isCanvasPreview: true)
    }
}

private enum CastleInfoV2PreviewData {
    static let hirosaki: Castle = {
        let json = #"""
        {
          "id": 4,
          "name": "弘前城",
          "jpName": "ひろさきじょう",
          "area": "北海道・東北",
          "city": "青森県",
          "address": "〒036-8356 青森県弘前市下白銀町1",
          "access": "從 JR 奧羽本線弘前站搭乘弘南巴士（100 日圓循環巴士），於市政府前下車後步行即可抵達。\n\n本丸・北之郭開放時間依季節調整；日本 100 名城印章設於弘前城資訊館。",
          "description": "天守原本是一座華麗的五層天守，位於本丸的西南角。寬永四年（1627 年）因雷擊焚毀，受《武家諸法度》限制，後以角櫓之名重建為現今的三層天守。弘前城的天守閣是關東以北唯一於江戶時代重建的天守，亦名列日本現存十二天守之一。\n\n因本丸東側石垣有坍塌風險，修繕計畫曾以曳屋技術，在不拆解天守的情況下將天守移動約 77 公尺。",
          "castleType": "平山城",
          "constructionPeriod": "慶長16年（1611）",
          "builder": "津軽信牧",
          "mainLords": "津軽氏",
          "isFavorite": false,
          "isFeatured": false,
          "url": "http://www.city.hirosaki.aomori.jp/ishigaki/index.html",
          "imageName": "弘前城",
          "imageURL": [
            "https://www.100finecastles.com/wordpress/wp-content/uploads/2009/12/hirosakijo2.jpg",
            "https://www.100finecastles.com/wordpress/wp-content/uploads/2014/10/4-hirosaki-jo-3-e1412911933769.jpg",
            "https://www.100finecastles.com/wordpress/wp-content/uploads/2013/11/4-hirosaki-jo-e1384696780605.jpg"
          ],
          "coordinates": {
            "latitude": 40.605040071,
            "longitude": 140.46400317602036
          }
        }
        """#
        return try! JSONDecoder().decode(Castle.self, from: Data(json.utf8))
    }()
}
