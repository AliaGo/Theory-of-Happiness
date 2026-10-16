//
//  HomepageView.swift
//  TOH
//
//  Created by Alia on 2025/2/6.
//

import Foundation
import SwiftUI


struct HomepageView: View {
    
    @StateObject private var viewModel = HomepageViewModel()
    @State private var showClanPicker = false
    
    //@Environment(ModelData.self) var modelData //地端資料
    
    //This path can come from environmene object View Model
    @Binding var path: [HomeNavigation]
    
    var castlebuttonItems: [String] = ["北海道・東北", "関東・甲信越", "北陸・東海", "近畿", "中国・四国", "九州・沖縄"]
    @State var selectedIndex1 = 0
    
    @Namespace private var buttonItemTransition1
    var isActive: Bool = false
    @State var isHokkaido: Bool = true
    @State var isKantou: Bool = false
    @State var isNorth: Bool = false
    @State var isKansai: Bool = false
    @State var isCenter: Bool = false
    @State var isKyushu: Bool = false
    
    var HokkaidoCastle: [Castle] {
        viewModel.castles.filter {
            $0.id < 14
        }
    }
    var KantouCastle: [Castle] {
        viewModel.castles.filter {
            $0.id >= 14 && $0.id < 33
        }
    }
    var NorthCastle: [Castle] {
        viewModel.castles.filter {
            $0.id >= 33 && $0.id < 49
        }
    }
    var KansaiCastle: [Castle] {
        viewModel.castles.filter {
            $0.id >= 49 && $0.id < 63
        }
    }
    var CenterCastle: [Castle] {
        viewModel.castles.filter {
            $0.id >= 63 && $0.id < 85
        }
    }
    var KyushuCastle: [Castle] {
        viewModel.castles.filter {
            $0.id >= 85 && $0.id < 101
        }
    }
    
    // Homepage Ramen 100
    var ramenbuttonItems: [String] = ["Osaka", "Tokyo", "East", "West" ]
    @State var selectedIndex2 = 0
    @Namespace private var buttonItemTransition
    //var isActive: Bool = false
    @State var isOsaka: Bool = true
    @State var isTokyo: Bool = false
    @State var isEast: Bool = false
    @State var isWest: Bool = false
    
    
    var EastRamen: [Ramen] {
        viewModel.ramens.filter {
            $0.id > 3000 && $0.id < 4000
        }
    }
    var WestRamen: [Ramen] {
        viewModel.ramens.filter {
            $0.id > 4000 && $0.id < 5000
        }
    }
    var TokyoRamen: [Ramen] {
        viewModel.ramens.filter {
            $0.id > 2000 && $0.id < 3000
        }
    }
    var OsakaRamen: [Ramen] {
        viewModel.ramens.filter {
            $0.id > 1000 && $0.id < 2000
        }
    }
    
    // Homepage Taipei Ramen
    var twRamenbuttonItems: [String] = ["red", "orange", "green", "blue", "yellow", "brown", "airport" ]
    @State var selectedIndex3 = 0
    @Namespace private var buttonItemTransition2
    //var isActive: Bool = false
    @State var isRed: Bool = true
    @State var isOrange: Bool = false
    @State var isGreen: Bool = false
    @State var isBlue: Bool = false
    @State var isYellow: Bool = false
    @State var isBrown: Bool = false
    @State var isAirport: Bool = false
    
    
    var RedRamen: [TWRamen] {
        viewModel.twRamens.filter {
            $0.mrtLine.contains("red")
        }
    }
    var OrangeRamen: [TWRamen] {
        viewModel.twRamens.filter {
            $0.mrtLine.contains("orange")
        }
    }
    var GreenRamen: [TWRamen] {
        viewModel.twRamens.filter {
            $0.mrtLine.contains("green")
        }
    }
    var BlueRamen: [TWRamen] {
        viewModel.twRamens.filter {
            $0.mrtLine.contains("blue")
        }
    }
    var YellowRamen: [TWRamen] {
        viewModel.twRamens.filter {
            $0.mrtLine.contains("yellow")
        }
    }
    var BrownRamen: [TWRamen] {
        viewModel.twRamens.filter {
            $0.mrtLine.contains("brown")
        }
    }
    var AirportRamen: [TWRamen] {
        viewModel.twRamens.filter {
            $0.mrtLine.contains("airport")
        }
    }

    // MARK: - 共用的 navigationDestination 內容
    // 4 個地方都呼叫這個方法，之後要新增/修改畫面只要改這裡一處即可，
    // 不用擔心改了 A 忘記改 B、C、D。
    @ViewBuilder
    private func homeDestination(for screen: HomeNavigation) -> some View {
        switch screen {
            case .child: CastleView()
            case .secondChild: RamenListView(ramens: viewModel.ramens)
            case .thirdChild: TWRamenListView(ramens: viewModel.twRamens)
        }
    }
    
    var body: some View {
        
        NavigationStack(path: $path.animation(.easeOut)){
            VStack(spacing: 25) {
                VStack(spacing: 14) {
                    HStack(alignment: .bottom, spacing: 10) {
                        Spacer()
                        
                        
                        NavigationLink {
                            PointShopView()
                        }label: {
                            Image("point")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25, alignment: .leading)
                        }
                        
                        Button{
                            
                        }label: {
                            Image("bell.badge")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.myGreen2)
                                .frame(width: 25, height: 25, alignment: .leading)
                        }.padding(.trailing, 4)

                    }
                    .padding(.horizontal, 20)
                    
                    HStack(spacing: 12) {
                        if let kamonName = viewModel.user?.kamonName,
                           !kamonName.isEmpty {
                            Image(kamonName)
                                .resizable()
                                .renderingMode(.template)
                                .scaledToFit()
                                .foregroundStyle(Color("MyGreen1"))
                                .frame(width: 36, height: 36)
                                .padding(8)
                                .background(Color("MyGreen1").opacity(0.1), in: Circle())
                        }

                        VStack(alignment: .leading) {
                            Text("武將大人，今日也要再下一城嗎？")
                                .font(.caption)
                                .foregroundStyle(.secondary)

                            HStack(spacing: 6) {
                                Text(viewModel.user?.userNickname ?? "未設定")
                                if let clan = viewModel.user?.samuraiClan, !clan.isEmpty {
                                    Text(clan)
                                        .font(.caption.bold())
                                        .foregroundStyle(Color("MyGreen1"))
                                        .padding(.horizontal, 7)
                                        .padding(.vertical, 3)
                                        .background(Color("MyGreen1").opacity(0.12), in: Capsule())
                                }
                            }
                                .font(.system(size: 24, weight: .bold))
                                .padding(.top, 1)
                            
                            Label("天下統一之路，仍在延續。", systemImage: "flag.checkered")
                                .font(.caption.weight(.medium))
                                .foregroundStyle(Color("MyGreen1"))
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 20)

                    HStack(spacing: 8) {
                        HomeProgressStatCard(
                            icon: "seal.fill",
                            title: "印章",
                            value: "\(viewModel.user?.stamps ?? 0)",
                            tint: Color("MyGreen1")
                        )
                        HomeProgressStatCard(
                            icon: "p.circle.fill",
                            title: "點數",
                            value: "\(viewModel.user?.points ?? 0)",
                            tint: .orange
                        )
                        HomeProgressStatCard(
                            icon: "crown.fill",
                            title: "攻城排名",
                            value: viewModel.castleRank.map { "#\($0)" } ?? "無排名",
                            tint: .yellow
                        )
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 2)

                    ScrollView(.vertical){
                        VStack{
                            HStack(alignment: .center, spacing: 15) {
                                Text("Castles 100")
                                    .fontWeight(.semibold)
                                    .font(.system(size: 25))
                                    .foregroundStyle(.black)
                                    .frame(maxWidth: .infinity ,alignment: .leading)
                                
                                Button(action: {
                                    path.append(.child)  //push 到 CastleListView
                                }) {
                                    HStack {
                                        Text("SEE ALL")
                                            .font(.system(size: 15))
                                            .fontWeight(.semibold)
                                            .foregroundStyle(.myGreen2)

                                        Image("seeMore")
                                            .frame(alignment: .trailing)
                                            .padding(.trailing, 30)
                                    }
                                }
                                
                                //.navigationTitle("Home")
                                
                                
                            }.padding(.leading, 30)
                                .padding(.vertical, 5)
                            ScrollView(.horizontal, showsIndicators: false){
                                HStack{
                                    ForEach(castlebuttonItems.indices, id: \.self) { index in
                                        
                                        TabbarItem(name: castlebuttonItems[index], isActive: selectedIndex1 == index, namespace: buttonItemTransition1)
                                            .onTapGesture {
                                                withAnimation(.easeInOut) {
                                                    selectedIndex1 = index
                                                }
                                                if selectedIndex1 == 0 {
                                                    isHokkaido = true
                                                    isKantou = false
                                                    isNorth = false
                                                    isKansai = false
                                                    isCenter = false
                                                    isKyushu = false
                                                }
                                                if selectedIndex1 == 1 {
                                                    isHokkaido = false
                                                    isKantou = true
                                                    isNorth = false
                                                    isKansai = false
                                                    isCenter = false
                                                    isKyushu = false
                                                }
                                                if selectedIndex1 == 2 {
                                                    isHokkaido = false
                                                    isKantou = false
                                                    isNorth = true
                                                    isKansai = false
                                                    isCenter = false
                                                    isKyushu = false
                                                }
                                                if selectedIndex1 == 3 {
                                                    isHokkaido = false
                                                    isKantou = false
                                                    isNorth = false
                                                    isKansai = true
                                                    isCenter = false
                                                    isKyushu = false
                                                }
                                                if selectedIndex1 == 4 {
                                                    isHokkaido = false
                                                    isKantou = false
                                                    isNorth = false
                                                    isKansai = false
                                                    isCenter = true
                                                    isKyushu = false
                                                }
                                                if selectedIndex1 == 5 {
                                                    isHokkaido = false
                                                    isKantou = false
                                                    isNorth = false
                                                    isKansai = false
                                                    isCenter = false
                                                    isKyushu = true
                                                }
                                                
                                            }
                                        
                                    }
                                    
                                }.padding(.leading, 30)
                            }
                            .scrollIndicators(.hidden)
                            
                            ScrollView(.horizontal) {
                                if isHokkaido {
                                    CastleSwitchView(castleArray: HokkaidoCastle)
                                }
                                if isKantou {
                                    CastleSwitchView(castleArray: KantouCastle)
                                }
                                if isNorth {
                                    CastleSwitchView(castleArray: NorthCastle)
                                }
                                if isKansai {
                                    CastleSwitchView(castleArray: KansaiCastle)
                                }
                                if isCenter {
                                    CastleSwitchView(castleArray: CenterCastle)
                                }
                                if isKyushu {
                                    CastleSwitchView(castleArray: KyushuCastle)
                                }
                                
                            }
                            .fixedSize(horizontal: false, vertical: true)
                            .scrollIndicators(.hidden)
                            
                            
                        }
                        .navigationDestination(for: HomeNavigation.self) { screen in
                            homeDestination(for: screen)
                        }
                        .padding(.vertical, 10)
                        
                        
                        VStack {
                            HStack(alignment: .center, spacing: 15) {
                                Text("Ramen 100")
                                    .fontWeight(.semibold)
                                    .font(.system(size: 25))
                                    .foregroundStyle(.black)
                                    .frame(maxWidth: .infinity ,alignment: .leading)
                                
                                NavigationLink(value: HomeNavigation.secondChild) {
                                    Text("SEE ALL")
                                        .font(.system(size: 15))
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.myGreen2)
                                    
                                    Image("seeMore")
                                        .frame(alignment: .trailing)
                                        .padding(.trailing, 30)
                                    
                                    
                                }
                                
                                
                                
                                //.navigationTitle("Home")
                                 
                            }.padding(.leading, 30)
                            
                            HStack{
                                ForEach(ramenbuttonItems.indices, id: \.self) { index in

                                    TabbarItem(name: ramenbuttonItems[index], isActive: selectedIndex2 == index, namespace: buttonItemTransition)
                                        .onTapGesture {
                                            withAnimation(.easeInOut) {
                                                selectedIndex2 = index
                                            }
                                            if selectedIndex2 == 0 {
                                                isOsaka = true
                                                isTokyo = false
                                                isEast = false
                                                isWest = false
                                            }
                                            if selectedIndex2 == 1 {
                                                isOsaka = false
                                                isTokyo = true
                                                isEast = false
                                                isWest = false
                                            }
                                            if selectedIndex2 == 2 {
                                                isOsaka = false
                                                isTokyo = false
                                                isEast = true
                                                isWest = false
                                            }
                                            if selectedIndex2 == 3 {
                                                isOsaka = false
                                                isTokyo = false
                                                isEast = false
                                                isWest = true
                                            }
                                            
                                        }
                                        
                                }
                                
                            }.padding(.leading, 10)
                            
                            
                            ScrollView(.horizontal) {
                                ListRamenOnHome(isWhere: isOsaka, list: OsakaRamen)
                                ListRamenOnHome(isWhere: isTokyo, list: TokyoRamen)
                                ListRamenOnHome(isWhere: isEast, list: EastRamen)
                                ListRamenOnHome(isWhere: isWest, list: WestRamen)
                            }
                            .fixedSize(horizontal: false, vertical: true)
                            .scrollIndicators(.hidden)
                             
                             
                        }
                        .navigationDestination(for: HomeNavigation.self) { screen in
                            homeDestination(for: screen)
                        }
                        .padding(.vertical, 10)
                        
                        VStack {
                            HStack(alignment: .center, spacing: 15) {
                                Text("Taipei Ramen")
                                    .fontWeight(.semibold)
                                    .font(.system(size: 25))
                                    .foregroundStyle(.black)
                                    .frame(maxWidth: .infinity ,alignment: .leading)
                            
                                
                                NavigationLink(value: HomeNavigation.thirdChild) {
                                    Text("SEE ALL")
                                        .font(.system(size: 15))
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.myGreen2)
                                    
                                    Image("seeMore")
                                        .frame(alignment: .trailing)
                                        .padding(.trailing, 30)
                                    
                                    
                                }
                                
                                
                                
                                //.navigationTitle("Home")
                                 
                            }.padding(.leading, 30)
                            
                            ScrollView(.horizontal, showsIndicators: false){
                                HStack{
                                    ForEach(twRamenbuttonItems.indices, id: \.self) { index in

                                        TabbarItem(name: twRamenbuttonItems[index], isActive: selectedIndex3 == index, namespace: buttonItemTransition2)
                                            .onTapGesture {
                                                withAnimation(.easeInOut) {
                                                    selectedIndex3 = index
                                                }
                                                if selectedIndex3 == 0 {
                                                    isRed = true
                                                    isOrange = false
                                                    isGreen = false
                                                    isBlue = false
                                                    isYellow = false
                                                    isBrown = false
                                                    isAirport = false
                                                }
                                                if selectedIndex3 == 1 {
                                                    isRed = false
                                                    isOrange = true
                                                    isGreen = false
                                                    isBlue = false
                                                    isYellow = false
                                                    isBrown = false
                                                    isAirport = false
                                                }
                                                if selectedIndex3 == 2 {
                                                    isRed = false
                                                    isOrange = false
                                                    isGreen = true
                                                    isBlue = false
                                                    isYellow = false
                                                    isBrown = false
                                                    isAirport = false
                                                }
                                                if selectedIndex3 == 3 {
                                                    isRed = false
                                                    isOrange = false
                                                    isGreen = false
                                                    isBlue = true
                                                    isYellow = false
                                                    isBrown = false
                                                    isAirport = false
                                                }
                                                if selectedIndex3 == 4 {
                                                    isRed = false
                                                    isOrange = false
                                                    isGreen = false
                                                    isBlue = false
                                                    isYellow = true
                                                    isBrown = false
                                                    isAirport = false
                                                }
                                                if selectedIndex3 == 5 {
                                                    isRed = false
                                                    isOrange = false
                                                    isGreen = false
                                                    isBlue = false
                                                    isYellow = false
                                                    isBrown = true
                                                    isAirport = false
                                                }
                                                if selectedIndex3 == 6 {
                                                    isRed = false
                                                    isOrange = false
                                                    isGreen = false
                                                    isBlue = false
                                                    isYellow = false
                                                    isBrown = false
                                                    isAirport = true
                                                }
                                                
                                            }
                                            
                                    }
                                    
                                }
                            }.padding(.leading, 30)
                            .scrollIndicators(.hidden)
                            
                            
                            ScrollView(.horizontal) {
                                ListTWRamenOnHome(isWhere: isRed, list: RedRamen)
                                ListTWRamenOnHome(isWhere: isOrange, list: OrangeRamen)
                                ListTWRamenOnHome(isWhere: isGreen, list: GreenRamen)
                                ListTWRamenOnHome(isWhere: isBlue, list: BlueRamen)
                                ListTWRamenOnHome(isWhere: isYellow, list: YellowRamen)
                                ListTWRamenOnHome(isWhere: isBrown, list: BrownRamen)
                                ListTWRamenOnHome(isWhere: isAirport, list: AirportRamen)
                            }
                            .fixedSize(horizontal: false, vertical: true)
                            .scrollIndicators(.hidden)
                             
                             
                        }
                        .navigationDestination(for: HomeNavigation.self) { screen in
                            homeDestination(for: screen)
                        }
                        .padding(.vertical, 10)
                        
                        
                        VStack {
                            Text("Castle Stamps")
                                .fontWeight(.semibold)
                                .font(.system(size: 25))
                                .foregroundStyle(.black)
                                .frame(maxWidth: .infinity ,alignment: .leading)
                                .padding(.leading, 30)
                            
                            
                            ScrollView(.horizontal) {
                                let rows = [GridItem()]
                                LazyHGrid(rows: rows, spacing: 20){
                                    NavigationLink {
                                        CastleStampsView(area: "北海道・東北", mainColor: Color.gray)
                                    } label: {
                                        StampBookView(blockImg: "北海道東北", backgroundColor: .white, frontColor: .black, num: 13)
                                    }
                                    
                                    NavigationLink {
                                        CastleStampsView(area: "関東・甲信越", mainColor: Color.yellow)
                                    } label: {
                                        StampBookView(blockImg: "関東甲信越", backgroundColor: .white, frontColor: .black, num: 19)
                                    }
                                    
                                    NavigationLink {
                                        CastleStampsView(area: "北陸・東海", mainColor: Color.blue)
                                    } label: {
                                        StampBookView(blockImg: "北陸東海", backgroundColor: .white, frontColor: .black, num: 16)
                                    }
                                    
                                    NavigationLink {
                                        CastleStampsView(area: "近畿", mainColor: Color.myGreen2)
                                    } label: {
                                        StampBookView(blockImg: "近畿", backgroundColor: .white, frontColor: .black, num: 14)
                                    }
                                    
                                    NavigationLink {
                                        CastleStampsView(area: "中国・四国", mainColor: Color.purple)
                                    } label: {
                                        StampBookView(blockImg: "中国四国", backgroundColor: .white, frontColor: .black, num: 22)
                                    }
                                    
                                    NavigationLink {
                                        CastleStampsView(area: "九州・沖縄", mainColor: Color.brown)
                                    } label: {
                                        StampBookView(blockImg: "九州沖縄", backgroundColor: .white, frontColor: .black, num: 16)
                                    }
                                    
                                }.padding(.leading, 30)
                                
                            }
                            .fixedSize(horizontal: false, vertical: true)
                            .scrollIndicators(.hidden)
                            
                        }
                        
                        VStack {
                            Text("Knowledges")
                                .fontWeight(.semibold)
                                .font(.system(size: 25))
                                .foregroundStyle(.black)
                                .frame(maxWidth: .infinity ,alignment: .leading)
                                .padding(.leading, 30)
                            
                            
                            ScrollView(.horizontal) {
                                let rows = [GridItem()]
                                LazyHGrid(rows: rows, spacing: 20){
                                    NavigationLink {
                                        
                                        CardView(type: "castleQA")
                                    } label: {
                                        BlockView(blockName: "日本城用語辭典", blockImg: "城堡辭典", backgroundColor: .white, frontColor: .black)
                                    }
                                    
                                    NavigationLink {
                                        CardView(type: "castleKnowledge")
                                    } label: {
                                        BlockView(blockName: "日本城相關知識", blockImg: "城堡知識", backgroundColor: .white, frontColor: .black)
                                    }
                                    
                                    NavigationLink {
                                        SamuraiIntroView()
                                    } label: {
                                        ZStack {
                                            BlockView(blockName: "戰國十大名將", blockImg: "samurai_intro", backgroundColor: Color("MyGreen1").opacity(0.12), frontColor: .black)
                                            if UIImage(named: "samurai_intro") == nil {
                                                Image(systemName: "flag.2.crossed.fill")
                                                    .font(.system(size: 38))
                                                    .foregroundStyle(Color("MyGreen1").opacity(0.25))
                                                    .offset(y: -34)
                                            }
                                        }
                                    }

                                    NavigationLink {
                                        RamenIntroView()
                                    } label: {
                                        BlockView(blockName: "拉麵大全", blockImg: "拉麵知識", backgroundColor: .white, frontColor: .black)
                                    }
                                    
                                }.padding(.leading, 30)
                                
                            }
                            .fixedSize(horizontal: false, vertical: true)
                            .scrollIndicators(.hidden)
                            
                            
                        }
                        .navigationDestination(for: HomeNavigation.self) { screen in
                            homeDestination(for: screen)
                        }
                    }
                    .scrollIndicators(.hidden)
                    
                }
                
                
                
            }
            .padding(.top, 30)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .bottom) //透過 frame 設定全螢幕背景顏色或圖片
            .background(Color.myBackground)
            
        }
        .navigationDestination(for: HomeNavigation.self) { screen in
            homeDestination(for: screen)
        }
        .task{
            do {
                try await viewModel.fetchData()
                try await viewModel.loadCurrentUser()
                showClanPicker = viewModel.needsClanSelection
                await viewModel.loadCastleRank()
            } catch {
                print("Error fetching data: \(error)")
            }
        }
        .sheet(isPresented: $showClanPicker) {
            ClanSelectionSheet { clan in
                try await viewModel.chooseSamuraiClan(clan)
                showClanPicker = false
            }
            .interactiveDismissDisabled()
        }
    }
}

private struct ClanSelectionSheet: View {
    @State private var selectedClan = SamuraiClan.all[0]
    @State private var isSaving = false
    @State private var errorMessage: String?

    let onConfirm: (SamuraiClan) async throws -> Void

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 14) {
                Image(systemName: "seal.fill")
                    .font(.system(size: 42))
                    .foregroundStyle(.black)
                    .padding(.top, 18)

                Text("武士大人，請選擇您的主君")
                    .font(.title3.bold())
                Text("歸屬武將後，即可領取專屬家紋，名列攻城榜。")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 28)

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                    ForEach(SamuraiClan.all) { clan in
                        Button {
                            selectedClan = clan
                        } label: {
                            HStack(spacing: 9) {
                                Image(clan.kamonName)
                                    .resizable()
                                    .renderingMode(.template)
                                    .scaledToFit()
                                    .foregroundStyle(.black)
                                    .frame(width: 30, height: 30)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(clan.name).font(.subheadline.bold())
                                    Text(clan.motto).font(.caption2).foregroundStyle(.secondary).lineLimit(1)
                                }
                                Spacer(minLength: 0)
                            }
                            .padding(10)
                            .background(Color.black.opacity(selectedClan == clan ? 0.08 : 0.025), in: RoundedRectangle(cornerRadius: 13))
                            .overlay(RoundedRectangle(cornerRadius: 13).stroke(selectedClan == clan ? Color.black : .clear, lineWidth: 2))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 20)

                Button {
                    guard !isSaving else { return }
                    isSaving = true
                    Task {
                        do {
                            try await onConfirm(selectedClan)
                        } catch {
                            errorMessage = "儲存失敗，請確認網路後再試一次。"
                        }
                        isSaving = false
                    }
                } label: {
                    HStack(spacing: 10) {
                        Image(selectedClan.kamonName)
                            .resizable()
                            .renderingMode(.template)
                            .scaledToFit()
                            .foregroundStyle(.black)
                            .frame(width: 25, height: 25)
                        Text("加入 \(selectedClan.name)，領取家紋")
                            .font(.headline)
                        if isSaving { ProgressView().tint(.white) }
                    }
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.white, in: RoundedRectangle(cornerRadius: 15))
                    .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.black, lineWidth: 1.5))
                }
                .disabled(isSaving)
                .padding(.horizontal, 20)
                .padding(.top, 4)

                if let errorMessage {
                    Text(errorMessage).font(.caption).foregroundStyle(.red)
                }
            }
            .padding(.bottom, 28)
        }
        .presentationDetents([.large])
        .presentationCornerRadius(28)
    }
}

#Preview("ContentView") {
    HomepageView(path: .constant([HomeNavigation]()))//.environment(ModelData())
}

// 轉場tabbar定義
struct TabbarItem: View {
    var name: String
    var isActive: Bool = false
    let namespace: Namespace.ID

    var body: some View {
        if isActive {
            Text(name)
                .font(.subheadline)
                .padding(.horizontal)
                .padding(.vertical, 4)
                .foregroundColor(.white)
                .background(Capsule().foregroundColor(.myGreen2))
                .matchedGeometryEffect(id: "highlightmenuitem", in: namespace)
        } else {
            Text(name)
                .font(.subheadline)
                .padding(.horizontal)
                .padding(.vertical, 4)
                .foregroundColor(.black)
                .background(Capsule().foregroundColor(.white))
        }

    }
}

private struct HomeProgressStatCard: View {
    let icon: String
    let title: String
    let value: String
    let tint: Color

    var body: some View {
        VStack(spacing: 3) {
            Image(systemName: icon)
                .font(.caption.bold())
                .foregroundStyle(tint)

            Text(title)
                .font(.caption2.weight(.medium))
                .foregroundStyle(.secondary)
                .lineLimit(1)

            Text(value)
                .font(.subheadline.bold())
                .foregroundStyle(.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.75)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 66)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 14))
        .overlay {
            RoundedRectangle(cornerRadius: 14)
                .stroke(tint.opacity(0.16), lineWidth: 1)
        }
        .shadow(color: .black.opacity(0.06), radius: 5, y: 2)
    }
}

struct CastleSwitchView: View {
    let castleArray: [Castle]
    let rows = [GridItem()]
    
    var body: some View{
        LazyHGrid(rows: rows, spacing: 20) {
            ForEach(castleArray, id: \.self) { c in
                NavigationLink{
                    CastleInfoView(castle: c)
                        
                }label: {
                    VStack(spacing: 3){
                        AsyncImage(url: URL(string: c.imageURL[0])) { image in
                            image.resizable()
                        } placeholder: {
                            Color.black
                        }
                        .frame(width: 80, height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        
                        Text(c.name)
                            .font(.system(size: 12))
                            .fontWeight(.semibold)
                            .foregroundStyle(.black)
                        
                        
                        HStack(spacing: 3) {
                            Image("扇子左")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 10, maxHeight: 10, alignment: .leading)
                                
                            
                            Text(c.city)
                                .foregroundStyle(.myGreen2)
                                .font(.system(size: 10))
                            
                            Image("扇子右")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 10, maxHeight: 10, alignment: .leading)
                        }
                            
                    }.padding(.bottom, 3)
                }
                
                
            }
        }.padding(.leading, 30)
    }
    
}

struct RamenListView: View {
    @StateObject private var viewModel = RamenViewModel()
    let ramens: [Ramen]
    @State private var searchText = ""
    @EnvironmentObject var userSession: UserSession
    @State private var showSignIn = false
    
    var filteredRamens: [Ramen] {
        if searchText.isEmpty {
            return ramens
        } else {
            return ramens.filter { $0.name.localizedStandardContains(searchText) ||
                $0.city.localizedStandardContains(searchText) ||
                $0.station.localizedStandardContains(searchText)
            }
        }
    }
    
    var features: [Ramen] {
        ramens.filter { $0.isFeatured }
    }
    
    var categories: [String: [Ramen]] {
        Dictionary(
            grouping: filteredRamens,
            by: { $0.category.rawValue }
        )
    }
    
    var body: some View {
            List{
                if features.count != 0{
                    PageView(pages: features.map { FeatureCard(ramen: $0) })
                        .listRowInsets(EdgeInsets())
                }
                
                ForEach(categories.keys.sorted(), id: \.self) { key in
                    CategoryRow(categoryName: key, items: categories[key]!){
                        showSignIn = true // 按下Fav按鈕需要登入時顯示登入畫面
                    }
                }
                .listRowInsets(EdgeInsets())
                
                
            }
            .listStyle(.inset)
            .navigationTitle("Ramen 100")
            .searchable(text: $searchText, prompt: "Search for a ramen")
            .fullScreenCover(isPresented: $showSignIn) {
                NavigationStack {
                    AuthenticationView(allowGuest: false)
                        .environmentObject(userSession)
                }
            }
        
        
        /*
         .task{
         try? await viewModel.getAllRamens()
         }
         */
         
    }
}
