import SwiftUI

enum ProfileRoute: Hashable {
    case guide
    case pointShop
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
                                icon: "shoeprints.fill",
                                title: "已蒐集印章",
                                value: "\(viewModel.userCollectedStamps?.count ?? 0)"
                            )
                            StatCard(
                                icon: "p.circle",
                                title: "取得點數",
                                value: "\(viewModel.user?.points ?? 0)"
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
                        title: "點數商店"
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

struct InfoRow: View {
    let icon: String
    let title: String

    var body: some View {
        HStack {
            Image(systemName: icon)
            Text(title)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .foregroundColor(.black)
    }
}
