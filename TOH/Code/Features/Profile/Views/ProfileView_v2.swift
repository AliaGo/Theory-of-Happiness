import SwiftUI
import FirebaseFirestore

enum ProfileRoute: Hashable {
    case guide
    case pointShop
    case leaderboard
}


struct ProfileView_v2: View {
    @StateObject private var viewModel = ProfileViewModel()

    @State private var showPhotoSheet = false
    @State private var showRamenSheet = false
    @State private var showCastleSheet = false

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {

                    // MARK: - Header
                    ProfileHeaderView(user: viewModel.user)

                    // MARK: - Content Area
                    VStack(spacing: 24) {

                        ShortcutGridView(
                            showPhotoSheet: $showPhotoSheet,
                            showRamenSheet: $showRamenSheet,
                            showCastleSheet: $showCastleSheet,
                            user: viewModel.user
                        )

                        LazyVGrid(columns: columns, spacing: 16) {
                            StatCard(
                                icon: "checkmark.seal.fill",
                                title: "已攻下百名城",
                                value: "\(viewModel.castleVisits.count)"
                            )
                            StatCard(
                                icon: "crown.fill",
                                title: "攻城排名",
                                value: viewModel.castleRank.map { "#\($0)" } ?? "無排名"
                            )
                            StatCard(
                                icon: "camera.fill",
                                title: "攻城日記",
                                value: "\(viewModel.castlePostCount)")
                            StatCard(icon: "camera.fill", title: "拉麵日記", value: "\(viewModel.ramenPostCount)")
                        }
                        .padding(.horizontal)

                        informationSection
                    }
                    .padding(.top, 24)
                    .background(Color.white)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: ProfileRoute.self) { route in
                switch route {
                case .guide:
                    GuideView()
                case .pointShop:
                    PointShopView()
                case .leaderboard:
                    CastleLeaderboardView(user: viewModel.user)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        SettingsView(
                            userNickname: viewModel.user?.userNickname ?? ""
                        )
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .font(.headline)
                            .foregroundColor(.black)
                    }
                }
            }
        }
        .task {
            try? await viewModel.loadCurrentUser()
            try? await viewModel.getCollectedStamps()
            await viewModel.loadCastleVisits()
            await viewModel.loadCastleRank()
            try? await viewModel.loadPostCounts(userId: viewModel.user?.userId ?? "")
        }
    }

    // MARK: - INFORMATION (Value-based Navigation)
    private var informationSection: some View {
        VStack(alignment: .leading, spacing: 12) {

            Text("More")
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.horizontal)

            VStack(spacing: 0) {
                NavigationLink(value: ProfileRoute.leaderboard) {
                    InfoRow(
                        icon: "crown.fill",
                        title: "日本百名城攻城榜"
                    )
                }

                Divider()

                NavigationLink(value: ProfileRoute.guide) {
                    InfoRow(
                        icon: "questionmark.circle",
                        title: "使用手冊"
                    )
                }

                Divider()

                NavigationLink(value: ProfileRoute.pointShop) {
                    InfoRow(
                        icon: "cart.fill",
                        title: "點數商店",
                        detail: "\(viewModel.user?.points ?? 0) 點"
                    )
                }
            }
            .background(Color(.systemGray6))
            .cornerRadius(14)
            .padding(.horizontal)
        }
        .padding(.bottom, 24)
    }
}

private struct LeaderboardEntry: Identifiable {
    let id: String
    let nickname: String
    let kamonName: String
    let count: Int
    let rank: Int
}

private struct ClanLeaderboardEntry: Identifiable {
    let id: String
    let name: String
    let kamonName: String
    let count: Int
    let rank: Int
}

private enum LeaderboardBoard: String, CaseIterable, Identifiable {
    case warriors = "武士榜"
    case clans = "氏族榜"

    var id: Self { self }
}

@MainActor
private final class CastleLeaderboardViewModel: ObservableObject {
    @Published private(set) var entries: [LeaderboardEntry] = []
    @Published private(set) var clanEntries: [ClanLeaderboardEntry] = []
    @Published private(set) var currentUserId = ""
    @Published private(set) var isLoading = true

    func load(user: DBUser?) async {
        isLoading = true
        do {
            let auth = try AuthenticationManager.shared.getAuthenticatedUser()
            currentUserId = auth.uid

            if let user {
                await UserManager.shared.syncLeaderboardProfile(user: user)
            }

            // visitors 是排名唯一必要資料；公開個人檔讀取失敗時，仍應顯示排名與預設身份。
            let visitors = try await Firestore.firestore().collectionGroup("visitors").getDocuments()
            let profiles = (try? await Firestore.firestore().collection("leaderboard_profiles").getDocuments())?.documents ?? []

            let counts = visitors.documents.reduce(into: [String: Int]()) { result, document in
                let userId = document.data()["userId"] as? String ?? document.documentID
                guard !userId.isEmpty else { return }
                result[userId, default: 0] += 1
            }
            let profilesByUserId: [String: (nickname: String, kamonName: String, samuraiClan: String)] = Dictionary(uniqueKeysWithValues: profiles.map { document in
                (
                    document.documentID,
                    (
                        nickname: document.data()["nickname"] as? String ?? "攻城者",
                        kamonName: document.data()["kamonName"] as? String ?? "",
                        samuraiClan: document.data()["samuraiClan"] as? String ?? ""
                    )
                )
            })
            let unsorted: [(id: String, count: Int, nickname: String, kamonName: String)] = counts.map { pair in
                let profile = profilesByUserId[pair.key]
                return (
                    id: pair.key,
                    count: pair.value,
                    nickname: profile?.nickname ?? "攻城者",
                    kamonName: profile?.kamonName ?? ""
                )
            }
            let sorted = unsorted
                .sorted { $0.count == $1.count ? $0.nickname < $1.nickname : $0.count > $1.count }

            var previousCount: Int?
            var currentRank = 0
            entries = sorted.enumerated().map { index, entry in
                if previousCount != entry.count { currentRank = index + 1 }
                previousCount = entry.count
                return LeaderboardEntry(id: entry.id, nickname: entry.nickname, kamonName: entry.kamonName, count: entry.count, rank: currentRank)
            }

            let clanCounts = counts.reduce(into: [String: Int]()) { result, pair in
                guard let clan = profilesByUserId[pair.key]?.samuraiClan,
                      !clan.isEmpty else { return }
                result[clan, default: 0] += pair.value
            }
            var sortedClans: [(clan: SamuraiClan, count: Int)] = []
            for clan in SamuraiClan.all {
                let total = clanCounts[clan.name, default: 0]
                sortedClans.append((clan: clan, count: total))
            }
            sortedClans.sort { left, right in
                if left.count == right.count {
                    return left.clan.name < right.clan.name
                }
                return left.count > right.count
            }

            var previousClanCount: Int?
            var currentClanRank = 0
            clanEntries = sortedClans.enumerated().map { index, entry in
                if previousClanCount != entry.count { currentClanRank = index + 1 }
                previousClanCount = entry.count
                return ClanLeaderboardEntry(
                    id: entry.clan.id,
                    name: entry.clan.name,
                    kamonName: entry.clan.kamonName,
                    count: entry.count,
                    rank: currentClanRank
                )
            }
        } catch {
            print("❌ leaderboard failed: \(error)")
        }
        isLoading = false
    }
}

private struct CastleLeaderboardView: View {
    let user: DBUser?
    @StateObject private var viewModel = CastleLeaderboardViewModel()
    @State private var selectedBoard: LeaderboardBoard = .warriors

    private var myEntry: LeaderboardEntry? { viewModel.entries.first { $0.id == viewModel.currentUserId } }
    private var topEntries: [LeaderboardEntry] { Array(viewModel.entries.prefix(100)) }

    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                leaderboardHero
                if viewModel.isLoading {
                    ProgressView().padding(.top, 48)
                } else {
                    Picker("排行榜類型", selection: $selectedBoard) {
                        ForEach(LeaderboardBoard.allCases) { board in
                            Text(board.rawValue).tag(board)
                        }
                    }
                    .pickerStyle(.segmented)

                    if selectedBoard == .warriors {
                        if viewModel.entries.isEmpty {
                            ContentUnavailableView("尚無攻城紀錄", systemImage: "building.columns", description: Text("成為第一位登上排行榜的攻城者！"))
                        } else {
                            podium
                            myRankCard
                            rankingList
                        }
                    } else {
                        clanRankingList
                    }
                }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("攻城排行榜")
        .navigationBarTitleDisplayMode(.inline)
        .task { await viewModel.load(user: user) }
    }

    private var leaderboardHero: some View {
        VStack(spacing: 8) {
            Image(systemName: "crown.fill")
                .font(.system(size: 38))
                .foregroundStyle(.yellow)
            Text("日本百名城攻城榜")
                .font(.title2.bold())
                .foregroundStyle(.white)
            Text("以已攻下的城堡數量決定排名")
                .font(.caption)
                .foregroundStyle(.white.opacity(0.85))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(LinearGradient(colors: [Color("MyGreen1"), Color("MyGreen2")], startPoint: .topLeading, endPoint: .bottomTrailing), in: RoundedRectangle(cornerRadius: 22))
    }

    private var podium: some View {
        HStack(alignment: .bottom, spacing: 10) {
            podiumEntry(1); podiumEntry(0); podiumEntry(2)
        }
    }

    private func podiumEntry(_ index: Int) -> some View {
        let entry = viewModel.entries.indices.contains(index) ? viewModel.entries[index] : nil
        let colors: [Color] = [.yellow, .gray, .orange]
        return VStack(spacing: 6) {
            ZStack(alignment: .topTrailing) {
                LeaderboardAvatar(
                    seed: entry?.id ?? "podium-\(index)",
                    kamonName: entry?.kamonName,
                    size: 42
                )
                podiumRankIcon(for: index)
                    .offset(x: 5, y: -5)
            }
            Text(entry?.nickname ?? "—").font(.caption.bold()).lineLimit(1)
            Text("\(entry?.count ?? 0) 座").font(.caption).foregroundStyle(.secondary)
            Text(entry.map { "#\($0.rank)" } ?? "—").font(.headline.bold()).foregroundStyle(.white).frame(maxWidth: .infinity).frame(height: index == 0 ? 80 : index == 1 ? 62 : 48).background(colors[index], in: RoundedRectangle(cornerRadius: 10))
        }.frame(maxWidth: .infinity)
    }

    @ViewBuilder
    private func podiumRankIcon(for index: Int) -> some View {
        if index == 0 {
            Text("⚔️")
                .font(.system(size: 19))
                .frame(width: 28, height: 28)
        } else {
            Image(systemName: "medal.fill")
                .font(.system(size: 19, weight: .bold))
                .foregroundStyle(index == 1 ? Color.gray : Color.orange)
                .frame(width: 28, height: 28)
        }
    }

    private var myRankCard: some View {
        HStack(spacing: 12) {
            Image(systemName: "person.crop.circle.badge.checkmark").font(.title).foregroundStyle(Color("MyGreen1"))
            VStack(alignment: .leading) { Text("我的排名").font(.caption).foregroundStyle(.secondary); Text(myEntry.map { "#\($0.rank) ・ \($0.count) / 100 座" } ?? "還沒有攻城紀錄").font(.headline) }
            Spacer()
            Image(systemName: "building.columns.fill").foregroundStyle(Color("MyGreen1"))
        }.padding().background(.background, in: RoundedRectangle(cornerRadius: 16)).shadow(color: .black.opacity(0.06), radius: 5)
    }

    private var rankingList: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Label("前 100 名攻城者", systemImage: "list.number")
                    .font(.headline)
                Spacer()
                Text("依已攻下城數排序")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            LazyVStack(spacing: 8) {
                ForEach(topEntries) { entry in
                    HStack(spacing: 12) {
                        Text("#\(entry.rank)").font(.headline.monospacedDigit()).frame(width: 42, alignment: .leading).foregroundStyle(entry.id == viewModel.currentUserId ? Color("MyGreen1") : .secondary)
                        LeaderboardAvatar(seed: entry.id, kamonName: entry.kamonName, size: 34)
                        Text(entry.nickname).fontWeight(entry.id == viewModel.currentUserId ? .bold : .regular)
                        Spacer()
                        Text("\(entry.count) / 100").font(.subheadline.bold()).monospacedDigit()
                    }
                    .padding()
                    .background(entry.id == viewModel.currentUserId ? Color("MyGreen1").opacity(0.12) : Color(.systemBackground), in: RoundedRectangle(cornerRadius: 14))
                }
            }

            if viewModel.entries.count > 100 {
                Text("目前共有 \(viewModel.entries.count) 位攻城者；榜單顯示前 100 名。")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 4)
            }
        }
    }

    private var clanRankingList: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Label("氏族攻略總榜", systemImage: "flag.2.crossed.fill")
                    .font(.headline)
                Spacer()
                Text("全氏族已攻下城堡總數")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            LazyVStack(spacing: 8) {
                ForEach(viewModel.clanEntries) { entry in
                    HStack(spacing: 12) {
                        Text("#\(entry.rank)")
                            .font(.headline.monospacedDigit())
                            .frame(width: 36, alignment: .leading)
                            .foregroundStyle(entry.rank == 1 ? .orange : .secondary)
                        Image(entry.kamonName)
                            .resizable()
                            .renderingMode(.template)
                            .scaledToFit()
                            .foregroundStyle(.black)
                            .frame(width: 34, height: 34)
                            .padding(6)
                            .background(Color.white, in: Circle())
                        Text(entry.name).fontWeight(.semibold)
                        Spacer()
                        Text("\(entry.count) 座")
                            .font(.subheadline.bold())
                            .monospacedDigit()
                    }
                    .padding()
                    .background(entry.rank == 1 ? Color.orange.opacity(0.12) : Color(.systemBackground), in: RoundedRectangle(cornerRadius: 14))
                }
            }
        }
    }
}

private struct LeaderboardAvatar: View {
    let seed: String
    let kamonName: String?
    let size: CGFloat

    var body: some View {
        KamonAvatar(seed: seed, preferredAssetName: kamonName, size: size)
    }
}

/// 沒有個人照片時顯示。以使用者 ID 決定樣式，讓每位攻城者保有固定家紋。
private struct KamonAvatar: View {
    let seed: String
    let preferredAssetName: String?
    let size: CGFloat

    private var variant: Int {
        guard let preferredAssetName, let index = assetNames.firstIndex(of: preferredAssetName) else {
            return seed.unicodeScalars.reduce(0) { ($0 + Int($1.value)) % assetNames.count }
        }
        return index
    }

    private let assetNames = [
        "kamon_akechi",
        "kamon_chosokabe",
        "kamon_Date",
        "kamon_mouli",
        "kamon_oda",
        "kamon_sanada",
        "kamon_takedabishi",
        "kamon_tokugawa",
        "kamon_toyotomi",
        "kamon_uesuki"
    ]

    var body: some View {
        ZStack {
            Circle().fill(Color.white)
            Circle().stroke(Color.black.opacity(0.7), lineWidth: max(1, size * 0.045))
            Image(assetNames[variant])
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .foregroundStyle(ink)
                .frame(width: size * 0.62, height: size * 0.62)
        }
        .frame(width: size, height: size)
    }

    private var ink: Color { .black }
}

struct InfoRow: View {
    let icon: String
    let title: String
    var detail: String? = nil

    var body: some View {
        HStack {
            Image(systemName: icon)
            Text(title)
            Spacer()
            if let detail {
                Text(detail)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Color("MyGreen1"))
            }
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .foregroundColor(.black)
    }
}
