import SwiftUI
import UIKit

private struct SamuraiProfile: Identifiable {
    let id: String
    let name: String
    let years: String
    let title: String
    let region: String
    let introduction: String
    let achievement: String
    var imageName: String { "samurai_" + id }

    static let all: [SamuraiProfile] = [
        .init(id: "tokugawa_ieyasu", name: "德川家康", years: "1543–1616", title: "江戶幕府的奠基者", region: "三河・關東", introduction: "出身三河，歷經與織田、豐臣政權的合作與競爭，逐步建立勢力。以耐心、外交與長期布局聞名。", achievement: "1600 年在關原之戰獲勝，1603 年就任征夷大將軍，開創江戶幕府。"),
        .init(id: "toyotomi_hideyoshi", name: "豐臣秀吉", years: "1537–1598", title: "完成天下統一", region: "尾張・大坂", introduction: "從織田信長麾下崛起，在本能寺之變後取得政權主導地位。擅長調度軍隊、築城與政治交涉。", achievement: "1590 年攻下小田原，完成日本統一；推行太閤檢地與刀狩，並發動侵略朝鮮的戰爭。"),
        .init(id: "oda_nobunaga", name: "織田信長", years: "1534–1582", title: "推動統一的革新者", region: "尾張・近畿", introduction: "以尾張為根據地，透過軍事征服與政治改革擴張勢力，成為戰國後期統一進程的關鍵人物。", achievement: "桶狹間之戰擊敗今川義元，1573 年終結足利義昭的幕府統治；1582 年於本能寺之變身亡。"),
        .init(id: "date_masamune", name: "伊達政宗", years: "1567–1636", title: "奧州獨眼龍", region: "奧州・仙台", introduction: "年輕時繼承伊達家，積極擴大東北勢力。後臣服於豐臣秀吉，並在德川政權下經營仙台藩。", achievement: "建立仙台城與城下町，促進領地發展，並派遣支倉常長參與慶長遣歐使節。"),
        .init(id: "chosokabe_motochika", name: "長宗我部元親", years: "1539–1599", title: "土佐的戰國大名", region: "土佐・四國", introduction: "以土佐為根據地，率領結合農業與軍事職能的一領具足勢力，逐步將影響力擴及四國。", achievement: "統一土佐並大幅擴張四國領地；1585 年臣服豐臣秀吉後保有土佐。"),
        .init(id: "akechi_mitsuhide", name: "明智光秀", years: "約 1528–1582", title: "本能寺之變的關鍵人物", region: "丹波・近江", introduction: "織田信長的重要家臣，參與近畿攻略與領地治理。其早年經歷與出生年份仍有不同說法。", achievement: "完成丹波攻略；1582 年發動本能寺之變，隨後於山崎之戰敗給羽柴秀吉。"),
        .init(id: "uesugi_kenshin", name: "上杉謙信", years: "1530–1578", title: "越後之龍", region: "越後・北陸", introduction: "原名長尾景虎，後繼承上杉姓與關東管領職位。以軍事能力聞名，長期與武田信玄爭奪信濃勢力範圍。", achievement: "多次與武田軍交戰於川中島，並向關東與北陸拓展勢力。"),
        .init(id: "sanada_yukimura", name: "真田幸村", years: "1567–1615", title: "大坂之陣的名將", region: "信濃・大坂", introduction: "本名真田信繁，「幸村」是後世廣為流傳的稱呼。真田昌幸之子，在大坂之陣中支持豐臣家。", achievement: "大坂冬之陣築起真田丸抵禦德川軍；夏之陣奮戰後戰死，成為後世軍記與故事中的知名武將。"),
        .init(id: "takeda_shingen", name: "武田信玄", years: "1521–1573", title: "甲斐之虎", region: "甲斐・信濃", introduction: "甲斐武田家的當主，透過軍事、外交與領地治理建立強大勢力，與上杉謙信形成著名的競爭關係。", achievement: "拓展信濃領地，推動治水與領國治理；1572 年於三方原之戰擊敗德川家康軍。"),
        .init(id: "mori_motonari", name: "毛利元就", years: "1497–1571", title: "中國地方的謀略家", region: "安藝・中國地方", introduction: "從安藝地方勢力崛起，運用聯盟、外交與軍事策略，在大內、尼子等勢力之間擴張毛利家。", achievement: "1555 年於嚴島之戰擊敗陶晴賢，奠定毛利家在中國地方的地位；「三矢之訓」是後世知名傳說。")
    ]
}

struct SamuraiIntroView: View {
    private let columns = [GridItem(.adaptive(minimum: 155), spacing: 16)]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("亂世中的十位名將")
                        .font(.title2.bold())
                    Text("認識戰國至江戶初期的重要人物，探索他們的領地與事蹟。")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text("依作者選列，非歷史排名。")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color("MyGreen1").opacity(0.1), in: RoundedRectangle(cornerRadius: 16))

                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(SamuraiProfile.all) { samurai in
                        NavigationLink {
                            SamuraiDetailView(samurai: samurai)
                        } label: {
                            VStack(alignment: .leading, spacing: 8) {
                                SamuraiPortrait(imageName: samurai.imageName, height: 150)
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(samurai.name).font(.headline)
                                    Text(samurai.years).font(.caption).foregroundStyle(.secondary)
                                    Text(samurai.title).font(.subheadline).foregroundStyle(Color("MyGreen1"))
                                }
                                .padding([.horizontal, .bottom], 12)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                            .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 12))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("戰國十大名將")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct SamuraiPortrait: View {
    let imageName: String
    let height: CGFloat

    var body: some View {
        GeometryReader { geometry in
            Group {
                if let portrait = UIImage(named: imageName) {
                    Image(uiImage: portrait)
                        .resizable()
                        .scaledToFill()
                } else {
                    ZStack {
                        Color("MyGreen1").opacity(0.12)
                        Image(systemName: "person.crop.square")
                            .font(.system(size: 44))
                            .foregroundStyle(Color("MyGreen1"))
                    }
                }
            }
            .frame(width: geometry.size.width, height: height)
            .clipped()
        }
        .frame(height: height)
        .accessibilityHidden(true)
    }
}

private struct SamuraiDetailView: View {
    let samurai: SamuraiProfile

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                SamuraiPortrait(imageName: samurai.imageName, height: 280)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                VStack(alignment: .leading, spacing: 8) {
                    Text(samurai.name).font(.largeTitle.bold())
                    Text(samurai.title).font(.title3).foregroundStyle(Color("MyGreen1"))
                    Text(samurai.years).foregroundStyle(.secondary)
                    Label(samurai.region, systemImage: "map").font(.subheadline)
                }
                VStack(alignment: .leading, spacing: 10) {
                    Text("人物介紹").font(.headline)
                    Text(samurai.introduction)
                }
                VStack(alignment: .leading, spacing: 10) {
                    Text("代表事蹟").font(.headline)
                    Text(samurai.achievement)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        .navigationTitle(samurai.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        SamuraiIntroView()
    }
}
