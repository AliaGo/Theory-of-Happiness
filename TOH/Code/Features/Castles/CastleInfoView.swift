//
//  CastleInfoView.swift
//  TOH
//
//  Created by Alia on 2025/2/17.
//

import SwiftUI
import MapKit
import SDWebImageSwiftUI

/// 保留舊版實作供比對；App 的所有入口已改用 CastleInfo_v2.swift 中的 CastleInfoView。
private struct LegacyCastleInfoView: View {
    //@EnvironmentObject var isFavorite: Binding<Bool>
    @StateObject private var viewModel = CastleViewModel()
    
    // 控制全螢幕顯示
    @State private var showFullScreen = false
    @State private var selectedIndex = 0
    @State private var showVisitSheet = false
    
    var castle: Castle
    //var isFavorite: Bool

    var areaIndex: Int {
        viewModel.castles.firstIndex(where: { $0.id == (castle.id)/1000 })!
    }
    var castleIndex: Int {
        viewModel.castles.firstIndex(where: { $0.id == castle.id })!
    }
    
    var isFavorite: Bool {
        viewModel.isFavorite
    }

    var body: some View {
        //@Bindable var viewModel = viewModel
        //@Binding var isFavorite = isFavorite
        
        
        ScrollView {
            LazyVStack(spacing: 0) {
            MapView(coordinate: castle.locationCoordinate, markerName: castle.name)
            .frame(height: 300)
            
            if let primaryImageURL = castle.imageURL.first {
                WebImage(
                    url: URL(string: primaryImageURL),
                    options: [.retryFailed, .scaleDownLargeImages]
                ) { image in
                    image.resizable()
                } placeholder: {
                    Color.black.overlay { ProgressView().tint(.white) }
                }
                .indicator(.activity)
                .transition(.fade)
                .frame(maxWidth: 200, maxHeight: 200)
                .clipShape(Circle())
                .overlay {
                    Circle().stroke(.white, lineWidth: 4)
                }
                .shadow(radius: 7)
                .offset(y: -130)
                .padding(.bottom, -130)
            } else {
                Image(systemName: "photo")
                    .font(.largeTitle)
                    .foregroundStyle(.secondary)
                    .frame(width: 200, height: 200)
                    .background(.black, in: Circle())
                    .offset(y: -130)
                    .padding(.bottom, -130)
            }
            
            
            VStack(alignment: .leading) {
                HStack {
                    Text(castle.name)
                        .font(.title)
                    Spacer()
                    Button {
                        showVisitSheet = true
                    } label: {
                        Label(
                            viewModel.hasVisited ? "已攻下・編輯" : "我攻下了",
                            systemImage: viewModel.hasVisited ? "checkmark.seal.fill" : "checkmark.seal"
                        )
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color("MyGreen1"))
                }
                
                 
                Text(castle.jpName)
                    .font(.title3)

                CastleCommunityStatsView(stats: viewModel.communityStats)

                CastleHistoryCard(castle: castle)
                
                HStack {
                    Text(castle.address)
                        .font(.subheadline)
                    Spacer()
                    Text(castle.city)
                        .font(.subheadline)
                }
                
                VStack(alignment: .leading){
                    Text("交通/印章設置場所/入館費用:")
                        .font(.subheadline)
                    Text(castle.access)
                        .font(.subheadline)
                }.padding(.top,5)
                
                Link("click to see more in homepage", destination: URL(string: castle.url)!)
                
                Divider()
                
                Text("Introduction：")
                    .font(.title2)
                Text(castle.description)
                        .font(.footnote)
                
                // LazyHStack 會在使用者滑到此區、且縮圖進入畫面時才開始載入。
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 8) {
                        ForEach(Array(castle.imageURL.enumerated()), id: \.offset) { idx, urlString in
                            WebImage(
                                url: URL(string: urlString),
                                options: [.retryFailed, .scaleDownLargeImages]
                            ) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                            } placeholder: {
                                Color.gray.opacity(0.2)
                                    .overlay { ProgressView().controlSize(.mini) }
                            }
                            .indicator(.activity)
                            .transition(.fade)
                            .frame(width: 76, height: 76)
                            .clipped()
                            .cornerRadius(10)
                            .contentShape(RoundedRectangle(cornerRadius: 10))
                            .onTapGesture {
                                selectedIndex = idx
                                showFullScreen = true
                            }
                        }
                    }
                }
                .frame(height: 76)
                
            }.padding()
            .ignoresSafeArea()
            .fullScreenCover(isPresented: $showFullScreen) {
                FullscreenImageViewer(urls: castle.imageURL, selectedIndex: selectedIndex)
            }
            }
        }
        .navigationTitle(castle.name)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showVisitSheet) {
            CastleVisitForm(castle: castle, visit: viewModel.visit, viewModel: viewModel)
                .presentationDetents([.height(560)])
                .presentationDragIndicator(.visible)
                .presentationCornerRadius(28)
        }
        .task{
            try? await viewModel.getAllCastles()
            try? await viewModel.checkUserFavoriteCastle(castleId: castle.id)
            await viewModel.loadVisitStatus(castleId: castle.id)
            await viewModel.loadCommunityStats(castleId: castle.id)
        }
        
    }
}

private struct CastleCommunityStatsView: View {
    let stats: CastleCommunityStats
    var body: some View {
        HStack(spacing: 10) {
            stat(icon: "person.2.fill", value: "\(stats.visitCount)", label: "勇者攻下")
            stat(icon: "heart.fill", value: stats.recommendationAverage.map { String(format: "%.1f", $0) } ?? "—", label: "推薦指數")
            stat(icon: "figure.hiking", value: stats.difficultyAverage.map { String(format: "%.1f", $0) } ?? "—", label: "攻城難度")
        }
        .padding(12)
        .background(Color("MyGreen1").opacity(0.12), in: RoundedRectangle(cornerRadius: 16))
        .padding(.vertical, 10)
    }
    private func stat(icon: String, value: String, label: String) -> some View {
        VStack(spacing: 3) { Image(systemName: icon).foregroundStyle(Color("MyGreen1")); Text(value).font(.title3.bold()); Text(label).font(.caption).foregroundStyle(.secondary) }.frame(maxWidth: .infinity)
    }
}

private struct CastleHistoryCard: View {
    let castle: Castle
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("城郭檔案", systemImage: "scroll.fill")
                .font(.headline)
                .foregroundStyle(Color("MyGreen1"))
            historyRow("mountain.2.fill", "城地種類", castle.castleType ?? "暫無資料")
            historyRow("calendar", "築城年代", castle.constructionPeriod ?? "暫無資料")
            historyRow("person.crop.circle.badge.plus", "築城者", castle.builder ?? "暫無資料")
            historyRow("crown.fill", "主要城主", castle.mainLords ?? "暫無資料")
        }
        .padding()
        .background(Color("MyGreen1").opacity(0.08), in: RoundedRectangle(cornerRadius: 18))
        .padding(.vertical, 4)
    }
    private func historyRow(_ icon: String, _ title: String, _ value: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: icon).frame(width: 20).foregroundStyle(Color("MyGreen1"))
            Text(title).font(.subheadline.weight(.medium)).frame(width: 70, alignment: .leading)
            Text(value).font(.subheadline).foregroundStyle(.secondary)
            Spacer(minLength: 0)
        }
    }
}

private struct CastleVisitForm: View {
    let castle: Castle
    let visit: UserCastleVisit?
    @ObservedObject var viewModel: CastleViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var date: Date
    @State private var visitType: CastleVisitType
    @State private var recommendation: Int
    @State private var difficulty: Int
    @State private var note: String
    @State private var showDelete = false
    init(castle: Castle, visit: UserCastleVisit?, viewModel: CastleViewModel) {
        self.castle = castle; self.visit = visit; _viewModel = ObservedObject(wrappedValue: viewModel)
        _date = State(initialValue: visit?.visitedDate ?? .now)
        let legacyVisitType: CastleVisitType
        switch visit?.visitType {
        case .entered: legacyVisitType = .fullConquest
        case .outsideOnly: legacyVisitType = .stampOnly
        case .some(let value): legacyVisitType = value
        case nil: legacyVisitType = .fullConquest
        }
        _visitType = State(initialValue: legacyVisitType)
        _recommendation = State(initialValue: visit?.recommendationRating ?? 5)
        _difficulty = State(initialValue: visit?.difficultyRating ?? 3)
        _note = State(initialValue: visit?.note ?? "")
    }
    var body: some View {
        NavigationStack { Form {
            Section { VStack(spacing: 8) { Image(systemName: "shield.lefthalf.filled").font(.system(size: 34)).foregroundStyle(Color("MyGreen1")); Text(visit == nil ? "記錄你的首次攻城" : "更新你的攻城戰報").font(.headline) }.frame(maxWidth: .infinity).padding(.vertical, 8) }
            Section("攻城資料") { DatePicker("造訪日期", selection: $date, displayedComponents: .date); Picker("攻城完成度", selection: $visitType) { Text("僅蓋章").tag(CastleVisitType.stampOnly); Text("付費參觀").tag(CastleVisitType.paidEntry); Text("全攻略").tag(CastleVisitType.fullConquest) } }
            Section("勇者評價") { StarRating(title: "推薦指數", rating: $recommendation); StarRating(title: "攻城難度", rating: $difficulty) }
            Section("攻城心得（選填）") { TextField("這座城最值得記住的是…", text: $note, axis: .vertical).lineLimit(3...6) }
            if visit != nil { Section { Button("移除攻城紀錄", role: .destructive) { showDelete = true } } }
        }.navigationTitle(castle.name).navigationBarTitleDisplayMode(.inline).toolbar { ToolbarItem(placement: .cancellationAction) { Button("取消") { dismiss() } }; ToolbarItem(placement: .confirmationAction) { Button("儲存") { viewModel.saveVisit(castle: castle, visitedDate: date, visitType: visitType, recommendationRating: recommendation, difficultyRating: difficulty, note: note); dismiss() } } }.confirmationDialog("移除這筆攻城紀錄？", isPresented: $showDelete) { Button("移除", role: .destructive) { viewModel.removeVisit(castleId: castle.id); dismiss() } }
        }
    }
}

private struct StarRating: View {
    let title: String; @Binding var rating: Int
    var body: some View { HStack { Text(title); Spacer(); ForEach(1...5, id: \.self) { value in Button { rating = value } label: { Image(systemName: value <= rating ? "star.fill" : "star").foregroundStyle(value <= rating ? .orange : .gray) }.buttonStyle(.plain) } } }
}
