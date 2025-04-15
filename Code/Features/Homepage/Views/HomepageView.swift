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
    
    @Environment(ModelData.self) var modelData //地端資料
    
    //This path can come from environmene object View Model
    @Binding var path: [HomeNavigation]
    
    let castleStamp = ["會津若松城", "五稜郭","松前城"]
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
    
    var body: some View {
        
        NavigationStack(path: $path.animation(.easeOut)){
            VStack(spacing: 25) {
                VStack{
                    HStack(alignment: .bottom, spacing: 15) {
                        Spacer()
                        
                        Button{
                            
                        }label: {
                            Image("point")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 25, maxHeight: 25, alignment: .leading)
                        }
                        Button{
                            
                        }label: {
                            Image("bell.badge")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 25, maxHeight: 25, alignment: .leading)
                        }
                        
                        Button{
                            
                        }label: {
                            Image("setting")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 25, maxHeight: 25, alignment: .leading)
                                .padding(.trailing, 15)
                        }
                        
                    }.padding(.bottom, 10)
                    
                    HStack{
                        Image("cat")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 60, maxHeight: 60)
                            .clipShape(Circle())
                            .overlay {
                                Circle().stroke(.white, lineWidth: 4)
                            }
                            .shadow(radius: 7)
                            .padding(.trailing, 10)
                        
                        VStack(alignment: .leading) {
                            Text("Alia")
                                .fontWeight(.semibold)
                                .font(.system(size: 20))
                                .padding(.bottom, 5)
                            
                            Text("Ramen Hunter")
                                .fontWeight(.semibold)
                                .font(.system(size: 12))
                                .foregroundStyle(.blue)
                        }
                        
                        VStack {
                            VStack{
                                Text("Castles Stamp")
                                    .fontWeight(.semibold)
                                    .font(.system(size: 12))
                                    .foregroundStyle(.myGreen2)
                                
                                Text("12")
                                    .fontWeight(.semibold)
                                    .font(.system(size: 18))
                                    .foregroundStyle(.myGreen1)
                            }.padding(.bottom, 10)
                            
                            VStack{
                                Text("Total Points")
                                    .fontWeight(.semibold)
                                    .font(.system(size: 12))
                                    .foregroundStyle(.myGreen2)
                                
                                Text("100")
                                    .fontWeight(.semibold)
                                    .font(.system(size: 18))
                                    .foregroundStyle(.myGreen1)
                            }
                        }
                        
                        VStack {
                            VStack{
                                Text("Ramen Coin")
                                    .fontWeight(.semibold)
                                    .font(.system(size: 12))
                                    .foregroundStyle(.myGreen2)
                                
                                Text("64")
                                    .fontWeight(.semibold)
                                    .font(.system(size: 18))
                                    .foregroundStyle(.myGreen1)
                            }.padding(.bottom, 10)
                            
                            VStack{
                                Text("Ranking")
                                    .fontWeight(.semibold)
                                    .font(.system(size: 12))
                                    .foregroundStyle(.myGreen2)
                                
                                Text("12")
                                    .fontWeight(.semibold)
                                    .font(.system(size: 18))
                                    .foregroundStyle(.myGreen1)
                            }
                        }
                    }.padding(.bottom, 5)
                    
                    
                    
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
                                
                            }.padding(.leading, -20)
                            /*
                            TabBarView(tabbarItems: [ "East", "West", "Tokyo", "Osaka" ])
                                .padding(.leading, 20)
                            */
                            ScrollView(.horizontal) {
                                let rows = [GridItem()]
                                if isOsaka{
                                    LazyHGrid(rows: rows, spacing: 20) {
                                        ForEach(OsakaRamen) { item in
                                            NavigationLink{
                                                RamenInfoView(ramen: item)
                                            } label: {
                                                RamenSingleView(ramen: item)
                                            }
                                        }
                                    }.padding(.leading, 30)
                                }
                                if isTokyo{
                                    LazyHGrid(rows: rows, spacing: 20) {
                                        ForEach(TokyoRamen) { item in
                                            NavigationLink{
                                                RamenInfoView(ramen: item)
                                            } label: {
                                                RamenSingleView(ramen: item)
                                            }
                                        }
                                    }.padding(.leading, 30)
                                }
                                if isEast{
                                    LazyHGrid(rows: rows, spacing: 20) {
                                        ForEach(EastRamen) { item in
                                            NavigationLink{
                                                RamenInfoView(ramen: item)
                                            } label: {
                                                RamenSingleView(ramen: item)
                                            }
                                        }
                                    }.padding(.leading, 30)
                                }
                                if isWest{
                                    LazyHGrid(rows: rows, spacing: 20) {
                                        ForEach(WestRamen) { item in
                                            NavigationLink{
                                                RamenInfoView(ramen: item)
                                            } label: {
                                                RamenSingleView(ramen: item)
                                            }
                                        }
                                    }.padding(.leading, 30)
                                }
                            }
                            .fixedSize(horizontal: false, vertical: true)
                            
                             
                             
                        }
                        .navigationDestination(for: HomeNavigation.self) { screen in
                            switch screen {
                                case .child: CastleView()
                                case .secondChild: RamenListView(ramens: viewModel.ramens)
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
                                        StampBookView(blockName: "北海道・東北", blockImg: "北海道東北", backgroundColor: .white, frontColor: .black)
                                    }
                                    
                                    NavigationLink {
                                        CastleStampsView(area: "関東・甲信越", mainColor: Color.yellow)
                                    } label: {
                                        StampBookView(blockName: "関東・甲信越", blockImg: "北海道東北", backgroundColor: .white, frontColor: .black)
                                    }
                                    
                                    NavigationLink {
                                        CastleStampsView(area: "北陸・東海", mainColor: Color.blue)
                                    } label: {
                                        StampBookView(blockName: "北陸・東海", blockImg: "北海道東北", backgroundColor: .white, frontColor: .black)
                                    }
                                    
                                    NavigationLink {
                                        CastleStampsView(area: "近畿", mainColor: Color.myGreen2)
                                    } label: {
                                        StampBookView(blockName: "近畿", blockImg: "北海道東北", backgroundColor: .white, frontColor: .black)
                                    }
                                    
                                    NavigationLink {
                                        CastleStampsView(area: "中国・四国", mainColor: Color.purple)
                                    } label: {
                                        StampBookView(blockName: "中国・四国", blockImg: "北海道東北", backgroundColor: .white, frontColor: .black)
                                    }
                                    
                                    NavigationLink {
                                        CastleStampsView(area: "九州・沖縄", mainColor: Color.brown)
                                    } label: {
                                        StampBookView(blockName: "九州・沖縄", blockImg: "北海道東北", backgroundColor: .white, frontColor: .black)
                                    }
                                    
                                }.padding(.leading, 30)
                                
                            }.fixedSize(horizontal: false, vertical: true)
                            
                            
                        }
                        
                        VStack {
                            Text("Ramen Stamps")
                                .fontWeight(.semibold)
                                .font(.system(size: 25))
                                .foregroundStyle(.black)
                                .frame(maxWidth: .infinity ,alignment: .leading)
                                .padding(.leading, 30)
                            
                            
                            ScrollView(.horizontal) {
                                let rows = [GridItem()]
                                LazyHGrid(rows: rows, spacing: 20){
                                    NavigationLink {
                                        
                                    } label: {
                                        StampBookView(blockName: "Osaka", blockImg: "北海道東北", backgroundColor: .white, frontColor: .black)
                                    }
                                    
                                    NavigationLink {
                                        
                                    } label: {
                                        StampBookView(blockName: "Tokyo", blockImg: "北海道東北", backgroundColor: .white, frontColor: .black)
                                    }
                                    
                                    NavigationLink {
                                        
                                    } label: {
                                        StampBookView(blockName: "East", blockImg: "北海道東北", backgroundColor: .white, frontColor: .black)
                                    }
                                    
                                    NavigationLink {
                                        
                                    } label: {
                                        StampBookView(blockName: "West", blockImg: "北海道東北", backgroundColor: .white, frontColor: .black)
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
                                        CardView().environment(modelData)
                                    } label: {
                                        BlockView(blockName: "日本城用語辭典", blockImg: "城堡辭典", backgroundColor: .white, frontColor: .black)
                                    }
                                    
                                    NavigationLink {
                                        
                                    } label: {
                                        BlockView(blockName: "日本城相關知識", blockImg: "城堡知識", backgroundColor: .white, frontColor: .black)
                                    }
                                    
                                    NavigationLink {
                                        
                                    } label: {
                                        BlockView(blockName: "拉麵豆知識", blockImg: "拉麵知識", backgroundColor: .white, frontColor: .black)
                                    }
                                    
                                }.padding(.leading, 30)
                                
                            }.fixedSize(horizontal: false, vertical: true)
                            
                            
                        }
                    }
                    
                }
                
                
                
                Spacer()
            }
            .padding(.top, 30)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .bottom) //透過 frame 設定全螢幕背景顏色或圖片
            .background(Color.myBackground)
            
        }
        .navigationDestination(for: HomeNavigation.self) { screen in
            switch screen {
                case .child: CastleView()
            case .secondChild: RamenListView(ramens: viewModel.ramens)
            }
        }
        .task{
            try? await viewModel.fetchData()
        }
    }
}

#Preview("ContentView") {
    HomepageView(path: .constant([HomeNavigation]())).environment(ModelData())
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
                            
                    }
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
