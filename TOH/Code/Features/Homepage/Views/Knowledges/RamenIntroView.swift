//
//  RamenIntro.swift
//  TOH
//
//  Created by Alia on 2025/8/9.
//

import SwiftUI

// MARK: - Models

enum RamenCategory: String, CaseIterable, Identifiable {
    case shoyu = "醬油"
    case tonkotsu = "豚骨"
    case toripaitan = "雞白湯"
    case shio = "鹽味"
    case miso = "味噌"
    case niboshi = "煮干"
    case threeGreat = "三大拉麵"
    case regional = "地方拉麵"

    var id: String { rawValue }

    var subtitle: String {
        switch self {
        case .shoyu: return "清澄琥珀色，鮮鹹中帶一絲甘甜"
        case .tonkotsu: return "白濁濃厚，骨髓熬出的綿密口感"
        case .toripaitan: return "乳白滑順，雞汁的溫柔鮮甜"
        case .shio: return "清透見底，鮮味直接不加修飾"
        case .miso: return "濃醇厚實，發酵豆香撞擊辣油"
        case .niboshi: return "海味直衝腦門，苦韻回甘"
        case .threeGreat: return "札幌 / 喜多方 / 博多"
        case .regional: return "日本各地自由發揮的新世代"
        }
    }

    var imageName: String {
        switch self {
        case .shoyu: return "醬油"
        case .tonkotsu: return "豚骨"
        case .toripaitan: return "雞白湯"
        case .shio: return "鹽味"
        case .miso: return "味噌"
        case .niboshi: return "煮干"
        case .threeGreat: return "喜多方"
        case .regional: return "家系"
        }
    }

    var soupDescription: String {
        switch self {
        case .shoyu:
            return "以醬油為基底的清湯或半濃湯，口感多變，常見於關東。"
        case .tonkotsu:
            return "以豚骨熬製數小時至數天，湯色乳白、濃郁有油脂感。"
        case .toripaitan:
            return "以雞骨或雞肉熬成的白湯，口感溫潤，香氣清雅。"
        case .shio:
            return "以鹽為主要調味的清湯，口味較清爽、強調原型食材。"
        case .miso:
            return "以發酵味噌作為調味，帶有濃郁與發酵香，常見於札幌風格。"
        case .niboshi: 
            return "小魚乾去頭去肚之後，拿來直接熬湯，或是磨碎之後加入湯頭。"
        case .threeGreat:
            return "代表三大流派：札幌（味噌）、喜多方（醬油）與博多（豚骨）。"
        case .regional:
            return "各地會有特殊做法與配料，形成多彩的地方特色拉麵。"
        }
    }
}

extension RamenCategory {
    /// 熬煮方法 — 講工法和邏輯，不只是「用什麼骨頭」
    var brewingMethod: String {
        switch self {
        case .shoyu:
            return "用雞骨或豬骨打底，加昆布、柴魚提鮮，最後用濃口醬油調色調味。醬油不是煮進湯裡的，是熬好湯後才「點」進去——這也是為什麼每家店的醬油配方都像秘密武器一樣藏著不說。"
        case .tonkotsu:
            return "豬大骨先汆燙去血水，再大火滾煮 8-12 小時，逼出骨髓裡的膠原蛋白，把骨頭熬到「化開」，湯才會白濁濃稠。火太小湯會清，火太大會苦——博多老師傅常說「湯是吼出來的」，指的就是那種持續大滾的氣勢。"
        case .toripaitan:
            return "雞骨架加雞爪，同樣是長時間大火滾煮，但時間通常比豚骨短（4-6 小時）。雞的膠質比豬少，所以湯體會比豚骨稀一點，但鮮甜度更直接，沒有豬油的厚重感。"
        case .shio:
            return "通常用昆布、小魚乾、雞骨做清湯底，全程小火慢熬，避免湯色變濁。鹽味拉麵最考驗食材本身的品質，因為沒有濃郁湯頭可以掩蓋瑕疵——是最誠實、也最難做好的一種。"
        case .miso:
            return "湯底先用豚骨或雞骨熬製，起鍋前才把味噌炒香、化進湯裡（不能直接煮，會破壞味噌的發酵香氣和鮮味）。札幌的店家常會把蒜末、薑末跟著味噌一起爆香，那股辛香就是味噌拉麵的靈魂。"
        case .niboshi:
            return "小魚乾連頭帶內臟一起熬煮，那股略帶苦味和魚腥的「煮干臭」其實是刻意保留的——拿掉內臟熬出來的湯反而會被老饕說「太乾淨、沒個性」。"
        case .threeGreat:
            return "札幌、喜多方、博多三地的拉麵幾乎是各自獨立演化出來的——札幌因為氣候寒冷發展出濃厚味噌湯底，喜多方靠近農業區用醬油搭粗捲麵，博多則因應碼頭工人快速進食的需求做出細麵秒煮的豚骨拉麵。"
        case .regional:
            return "地方拉麵的差異往往來自「地理限制」——比如四國德島因為靠海、缺乏淡水熬湯，發展出加生豬肉片和生雞蛋的獨特吃法；而北海道函館因為氣候極冷，鹽味拉麵反而比味噌更受歡迎。"
        }
    }

    /// 常見變化玩法 — 點餐術語、客製化選項
    var variations: String {
        switch self {
        case .shoyu:
            return "東京老店常見「中華麵」般的細捲麵搭配，配料簡單到只有海苔、筍乾、蔥花——醬油拉麵的精神是「湯好麵好就夠了」，配料越簡單越考驗功力。"
        case .tonkotsu:
            return "博多系的招牌是「替玉」（かえだま）——吃完麵先把麵單獨追加，湯留著繼續喝。麵的硬度還能客製，從「粉落とし」（幾乎生麵）到「バリカタ」（超硬）到普通熟度都有，老饕會直接喊硬度代號點餐。"
        case .toripaitan:
            return "近年流行把雞白湯做成「雙湯」吃法——一半原味雞湯、一半加辣油或柚子皮提味，吃到一半味道轉換，算是雞白湯派系裡比較新潮的玩法。"
        case .shio:
            return "鹽味拉麵很常搭配海鮮系澆頭，例如蛤蜊、干貝，靠海鮜的鮮甜疊加湯底鮮味；配菜常見柚子皮絲或法國香菜，帶一點清新尾韻。"
        case .miso:
            return "札幌系常見加一塊奶油或玉米粒漂在湯面——奶油是當地早期應對寒冷氣候、增加熱量的吃法，後來變成招牌特色；玉米則是因為北海道本身就是玉米產地，順勢成了標配。"
        case .niboshi:
            return "東京一帶流行「沾麵」（つけ麵）形式吃煮干湯——麵跟湯分開上桌，麵沾濃縮過的煮干湯吃，吃完還能跟店家要熱湯把剩下的沾汁稀釋成湯喝，叫「湯割り」，是內行人才知道的吃法。"
        case .threeGreat:
            return "三大拉麵其實常被互相「致敬」——東京很多拉麵店會同時提供醬油、味噌、豚骨三種湯底讓客人選，等於是把三大流派濃縮進一張菜單，方便新手一次比較三種風味。"
        case .regional:
            return "很多地方拉麵其實是「為了觀光」才被重新包裝、命名的——像和歌山拉麵原本只是當地居民的日常小吃，直到近代才被媒體歸納、宣傳成一個獨立流派，跟北海道三大拉麵的命名邏輯類似。"
        }
    }

    /// 冷知識 — 一句话的趣味事实
    var funFact: String {
        switch self {
        case .shoyu:
            return "醬油拉麵被視為「最初代」拉麵——1910 年代東京淺草的拉麵店「來來軒」用的就是醬油湯底，後來才衍生出豚骨、味噌等其他流派。"
        case .tonkotsu:
            return "豚骨拉麵的「白湯」其實是意外的產物——傳說 1947 年福岡一家店老闆因為臨時接待客人手忙脚乱把湯煮過頭、煮到變白濁，結果客人反而說好喝，誤打誤撞變成經典做法。"
        case .toripaitan:
            return "雞白湯在 2000 年代後才真正流行起來，比起豚骨、醬油算是「年輕派系」——很多人會誤以為它歷史悠久，其實它在拉麵世界裡算後輩。"
        case .shio:
            return "鹽味拉麵被認為是最古老的拉麵調味方式之一，因為「鹽」是最容易取得的調味料；函館鹽味拉麵甚至被列為北海道三大拉麵之一，跟味噌、醬油並列。"
        case .miso:
            return "味噌拉麵的誕生地札幌，其實是 1950 年代一家店老闆把客人剩下的味噌湯隨手倒進拉麵湯裡試吃，結果意外大受好評，才開始正式賣味噌拉麵。"
        case .niboshi:
            return "煮干湯曾經被認為是「太腥太土」的鄉下口味，直到 2000 年代東京沾麵風潮興起，煮干湯才被重新定位成「高級、講究」的選擇,風評整個翻轉。"
        case .threeGreat:
            return "「三大拉麵」這個說法其實是後來媒體歸納出來的行銷概念，三個地方在發展初期完全沒有互相參照，是各自獨立演化出截然不同的拉麵文化。"
        case .regional:
            return "日本「拉麵激戰區」的稱號，常常是地方政府主動推動的——把當地拉麵店集中包裝、辦活動宣傳，本意是想帶動觀光和地方經濟，類似台灣夜市美食街的概念。"
        }
    }
}
// MARK: - Models

struct RamenShop: Identifiable {
    let id = UUID()
    let name: String
    let prefecture: String
    let highlight: String      // 一句話的推薦理由
    let linkURL: URL?

    init(
        name: String,
        prefecture: String,
        highlight: String,
        link: String?
    ) {
        self.name = name
        self.prefecture = prefecture
        self.highlight = highlight
        self.linkURL = link.flatMap { URL(string: $0) }
    }
}

extension RamenCategory {
    /// 每個分類對應的代表店家（依排名順序排列），你自己填入真實資料
    var topShops: [RamenShop] {
        switch self {
        case .shoyu:
            return [
                RamenShop(name: "飯田商店", prefecture: "神奈川", highlight: "全日本排名第一美味，無需多言", link: "https://tabelog.com/tw/kanagawa/A1410/A141002/14038776/"),
                RamenShop(name: "らぁ麺や 嶋", prefecture: "東京", highlight: "特選白醬油拉麵，面面俱到", link: "https://tabelog.com/tw/tokyo/A1304/A130401/13247487/"),
                RamenShop(name: "麦と麺助", prefecture: "大阪", highlight: "三種地雞湯頭混合特選醬油，底蘊深厚", link: "https://tabelog.com/tw/osaka/A2701/A270101/27104891/"),
            ]
        case .tonkotsu:
            return [
                RamenShop(name: "博多一双 博多駅東本店", prefecture: "福岡", highlight: "經典博多風味搭配平打細麵", link: "https://tabelog.com/tw/fukuoka/A4001/A400101/40032701/"),
                RamenShop(name: "博多元氣一杯!!", prefecture: "福岡", highlight: "簡單暴力，衝擊性的奶油豚骨", link: "https://tabelog.com/tw/fukuoka/A4001/A400106/40000488/"),
            ]
        case .toripaitan:
            return [
                RamenShop(name: "麥×鷄", prefecture: "大阪", highlight: "心齋橋的綠洲", link: "https://tabelog.com/tw/osaka/A2701/A270201/27111796/"),
                RamenShop(name: "銀座 篝 本店", prefecture: "東京", highlight: "米其林必比登名店", link: "https://tabelog.com/tw/tokyo/A1301/A130101/13230021/"),
                RamenShop(name: "うまそうなラーメン屋", prefecture: "大阪", highlight: "泡系湯頭搭配招牌炙燒起司燉飯", link: "https://tabelog.com/tw/osaka/A2701/A270103/27135649/")
            ]
        case .shio:
            return [
                RamenShop(name: "銀座 八五", prefecture: "東京", highlight: "開業後連續多年入選百名店", link: "https://tabelog.com/tw/tokyo/A1301/A130101/13228602/"),
                RamenShop(name: "Homemade Ramen 麥苗", prefecture: "東京", highlight: "主打食材本身旨味的絕妙平衡", link: "https://tabelog.com/tw/tokyo/A1315/A131502/13194812/")
            ]
        case .miso:
            return [
                RamenShop(name: "麺屋大河", prefecture: "石川", highlight: "多樣化的味噌湯頭，首推蟹味噌", link: "https://tabelog.com/tw/ishikawa/A1701/A170101/17007507/"),
                RamenShop(name: "麺屋 彩未", prefecture: "北海道", highlight: "札幌超人氣店，孕育夢幻味噌拉麵", link: "https://tabelog.com/tw/hokkaido/A0101/A010303/1000018/")
            ]
        case .niboshi:
            return [
                RamenShop(name: "煮干中華そば専門 煮干丸", prefecture: "埼玉", highlight: "充分享受濃厚煮干風味，透過自行加入內臟油又是另一種層次", link: "https://tabelog.com/tw/saitama/A1101/A110101/11043682/"),
                RamenShop(name: "烈志笑魚油 麺香房 三く", prefecture: "大阪", highlight: "推薦：恋煮干し魚三，吃到一半跟店家要偽裝成中藥包的特製七味粉，又是直上天堂的滋味", link: "https://tabelog.com/tw/osaka/A2701/A270108/27058993/")
            ]
        case .threeGreat:
            return []
        case .regional:
            return [
                RamenShop(name: "青島食堂", prefecture: "新潟", highlight: "長岡生薑醬油發揮到極致", link: "https://tabelog.com/tw/niigata/A1502/A150201/15000040/"),
                RamenShop(name: "杭州飯店", prefecture: "新潟", highlight: "燕三條煮干背脂拉麵創始店，極粗麵搭配濃厚煮干令人上癮", link: "https://tabelog.com/tw/niigata/A1502/A150201/15000040/"),
                RamenShop(name: "家系總本山 吉村家", prefecture: "橫濱", highlight: "家系拉麵創始店，拉麵迷一生當中必朝聖之拉麵殿堂", link: "https://tabelog.com/tw/kanagawa/A1401/A140102/14090328/"),
                RamenShop(name: "坂內食堂", prefecture: "福島", highlight: "昭和33年創立的喜多方拉麵名店，早晨就可以享用", link: "https://tabelog.com/tw/fukushima/A0706/A070601/7000007/")
            ]
        }
    }
}

// MARK: - ViewModel

@MainActor
final class RamenIntroViewModel: ObservableObject {
    @Published var query: String = ""

    let categories: [RamenCategory] = RamenCategory.allCases
}

// MARK: - Intro View

struct RamenIntroView: View {
    @StateObject private var vm = RamenIntroViewModel()

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                headerView

                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(vm.categories) { category in
                        NavigationLink {
                            RamenCategoryDetailView(category: category)
                        } label: {
                            CategoryCard(category: category)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
            }
            .padding(.top)
        }
        .navigationTitle("拉麵大全")
        .navigationBarTitleDisplayMode(.inline)
        
    }

    private var headerView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    LinearGradient(
                        colors: [Color.orange.opacity(0.25), Color(.systemBackground)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 140)
                .padding(.horizontal)

            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("日本拉麵完全指南")
                        .font(.title2)
                        .bold()
                    Text("探索湯頭、配料與地區風味")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Image(systemName: "fork.knife")
                    .font(.largeTitle)
                    .foregroundStyle(.orange)
                    .padding()
                    .background(.background.opacity(0.7), in: RoundedRectangle(cornerRadius: 10))
            }
            .padding(.horizontal, 36)
        }
    }
}

// MARK: - Category Card

struct CategoryCard: View {
    let category: RamenCategory

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            RamenImage(name: category.imageName, height: 110)

            VStack(alignment: .leading, spacing: 4) {
                Text(category.rawValue)
                    .font(.headline)
                Text(category.subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding([.leading, .bottom, .trailing], 8)
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.secondarySystemBackground))
                .shadow(color: .black.opacity(0.08), radius: 4, y: 2)
        )
    }
}

// MARK: - Shared image view with graceful fallback

struct RamenImage: View {
    let name: String
    let height: CGFloat

    var body: some View {
        Group {
            if let uiImage = UIImage(named: name) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.15))
                    .overlay(
                        Image(systemName: "photo")
                            .font(.title2)
                            .foregroundStyle(.secondary)
                    )
            }
        }
        .frame(height: height)
        .frame(maxWidth: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: 5))
    }
}

// MARK: - Detail View

struct RamenCategoryDetailView: View {
    let category: RamenCategory

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                RamenImage(name: category.imageName, height: 220)
                    .clipShape(Rectangle())

                Group {
                    Text("\(category.rawValue) 介紹")
                        .font(.title2)
                        .bold()
                    Text(category.subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal)

                VStack(alignment: .leading, spacing: 12) {
                    SectionHeader(title: "湯頭與基底")
                    Text(category.soupDescription)
                        .padding(.horizontal)

                    SectionHeader(title: "熬煮方法")
                        Text(category.brewingMethod)
                            .padding(.horizontal)

                    SectionHeader(title: "吃法與變化")
                    Text(category.variations)
                        .padding(.horizontal)

                    SectionHeader(title: "冷知識")
                    Text(category.funFact)
                        .padding(.horizontal)
                
                    SectionHeader(title: "代表店家")

                    ForEach(Array(category.topShops.enumerated()), id: \.element.id) { index, shop in
                        ShopRow(rank: index + 1, shop: shop)
                    }
                }

                Spacer(minLength: 24)
            }
        }
        .navigationTitle(category.rawValue)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SectionHeader: View {
    let title: String
    var body: some View {
        Text(title)
            .font(.headline)
            .padding(.horizontal)
    }
}

struct ShopRow: View {
    let rank: Int
    let shop: RamenShop

    var body: some View {
        HStack(spacing: 12) {
            Text("\(rank)")
                .font(.headline)
                .foregroundStyle(.secondary)
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 2) {
                Text(shop.name)
                    .bold()
                Text(shop.prefecture)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(shop.highlight)
                    .font(.caption)
                    .foregroundStyle(.green)
            }

            Spacer()

            if let url = shop.linkURL {
                Link(destination: url) {
                    HStack(spacing: 4) {
                        Text("查看餐廳資訊")
                        Image(systemName: "arrow.up.right")
                    }
                    .font(.caption)
                }
            } else {
                Text("連結未提供")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

// MARK: - Preview

#Preview {
    RamenIntroView()
}
