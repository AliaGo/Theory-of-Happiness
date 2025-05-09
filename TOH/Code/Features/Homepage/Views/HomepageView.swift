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
    
    var body: some View {
        
        NavigationStack(path: $path.animation(.easeOut)){
            VStack(spacing: 25) {
                VStack{
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
                        }.padding(.trailing, 15)

                    }
                    
                    HStack(spacing: 30){
                        VStack(alignment: .leading) {
                            Text(viewModel.user?.userNickname ?? "未設定")
                                .fontWeight(.semibold)
                                .font(.system(size: 20))
                                .padding(.bottom, 5)
                            
                            Text("Ramen Lover")
                                .fontWeight(.semibold)
                                .font(.system(size: 12))
                                .foregroundStyle(.blue)
                        }
                        
                        HStack(spacing: 30) {
                            VStack{
                                Text("Stamps")
                                    .fontWeight(.semibold)
                                    .font(.system(size: 14))
                                    .foregroundStyle(.myGreen2)
                                
                                Text(String(viewModel.user?.stamps ?? 0))
                                    .fontWeight(.semibold)
                                    .font(.system(size: 16))
                                    .foregroundStyle(.myGreen1)
                            }
                            .background(Rectangle()
                                .foregroundColor(.white)
                                .frame(width: 70, height: 35)
                                .cornerRadius(5)
                                .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2))
                            
                            VStack{
                                Text("Points")
                                    .fontWeight(.semibold)
                                    .font(.system(size: 14))
                                    .foregroundStyle(.myGreen2)
                                
                                Text(String(viewModel.user?.points ?? 0))
                                    .fontWeight(.semibold)
                                    .font(.system(size: 16))
                                    .foregroundStyle(.myGreen1)
                            }.background(Rectangle()
                                .foregroundColor(.white)
                                .frame(width: 70, height: 35)
                                .cornerRadius(5)
                                .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2))
                            
                            VStack{
                                Text("Ranking")
                                    .fontWeight(.semibold)
                                    .font(.system(size: 14))
                                    .foregroundStyle(.myGreen2)
                                
                                Text(String(viewModel.user?.ranking ?? 0))
                                    .fontWeight(.semibold)
                                    .font(.system(size: 16))
                                    .foregroundStyle(.myGreen1)
                            }.background(
                                Rectangle()
                                    .foregroundColor(.white)
                                    .frame(width: 70, height: 35)
                                    .cornerRadius(5)
                                    .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2))
                        }
                        
                    }.padding(.bottom, 10)
                    
                    
                    
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
                                /*
                                NavigationLink(value: HomeNavigation.child) {
                                    Text("SEE ALL")
                                        .font(.system(size: 15))
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.myGreen2)
                                    
                                    Image("seeMore")
                                        .frame(alignment: .trailing)
                                        .padding(.trailing, 30)
                                }
                                */
                                
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
                            
                            
                            
                        }
                        .navigationDestination(for: HomeNavigation.self) { screen in
                            switch screen {
                                case .child: CastleView()
                                case .secondChild: RamenListView(ramens: viewModel.ramens)
                                case .thirdChild:
                                    TWRamenListView(ramens: viewModel.twRamens)
                            }
                        }
                        .padding(.vertical, 10)
                        
                        
                        VStack {
                            HStack(alignment: .center, spacing: 15) {
                                Text("Ramen 100")
                                    .fontWeight(.semibold)
                                    .font(.system(size: 25))
                                    .foregroundStyle(.black)
                                    .frame(maxWidth: .infinity ,alignment: .leading)
                                
                                /*
                                Button(action: {
                                    path.append(.secondChild)  //push 到 RamenListView
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
                                */
                                
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
                                
                            }.padding(.leading, 30)
                            
                            
                            ScrollView(.horizontal) {
                                ListRamenOnHome(isWhere: isOsaka, list: OsakaRamen)
                                ListRamenOnHome(isWhere: isTokyo, list: TokyoRamen)
                                ListRamenOnHome(isWhere: isEast, list: EastRamen)
                                ListRamenOnHome(isWhere: isWest, list: WestRamen)
                            }
                            .fixedSize(horizontal: false, vertical: true)
                            
                             
                             
                        }
                        .navigationDestination(for: HomeNavigation.self) { screen in
                            switch screen {
                                case .child: CastleView()
                                case .secondChild: RamenListView(ramens: viewModel.ramens)
                                case .thirdChild:
                                    TWRamenListView(ramens: viewModel.twRamens)
                            }
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
                            
                             
                             
                        }
                        .navigationDestination(for: HomeNavigation.self) { screen in
                            switch screen {
                                case .child: CastleView()
                                case .secondChild: RamenListView(ramens: viewModel.ramens)
                                case .thirdChild:
                                    TWRamenListView(ramens: viewModel.twRamens)
                            }
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
                                
                            }.fixedSize(horizontal: false, vertical: true)
                            
                            
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
                                        CardView(type: "ramenKnowledge")
                                    } label: {
                                        BlockView(blockName: "拉麵豆知識", blockImg: "拉麵知識", backgroundColor: .white, frontColor: .black)
                                    }
                                    
                                }.padding(.leading, 30)
                                
                            }.fixedSize(horizontal: false, vertical: true)
                            
                            
                        }
                    }
                    
                }
                
                
                
            }
            .padding(.top, 30)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .bottom) //透過 frame 設定全螢幕背景顏色或圖片
            .background(Color.myBackground)
            
        }
        .navigationDestination(for: HomeNavigation.self) { screen in
            switch screen {
                case .child: CastleView()
                case .secondChild: RamenListView(ramens: viewModel.ramens)
                case .thirdChild:
                    TWRamenListView(ramens: viewModel.twRamens)
            }
        }
        .task{
            do {
                try await viewModel.fetchData()
                try await viewModel.loadCurrentUser()
            } catch {
                print("Error fetching data: \(error)")
            }
        }
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
                    CategoryRow(categoryName: key, items: categories[key]!)
                }
                .listRowInsets(EdgeInsets())
                
                
            }
            .listStyle(.inset)
            .navigationTitle("Ramen 100")
            .searchable(text: $searchText, prompt: "Search for a ramen")
        
        /*
         .task{
         try? await viewModel.getAllRamens()
         }
         */
         
    }
}
