import SwiftUI

struct ProfileHeaderView: View {
    let user: DBUser?

    var body: some View {
        VStack(spacing: 0) {

            // MARK: - Top Background + Avatar
            ZStack(alignment: .bottomLeading) {
                headerBackground
                    .frame(maxHeight: 60)

                profileImage
                    .offset(x: 16, y: 60)
            }
            .padding(.bottom, 90) // 留空間給頭像浮出來

            // MARK: - Info Section
            VStack(alignment: .leading, spacing: 12) {

                // Nickname
                Text(user?.userNickname ?? "User")
                    .font(.title2)
                    .bold()

                // Start Date
                if let date = user?.dateCreated {
                    HStack(spacing: 6) {
                        Image(systemName: "calendar")
                            .font(.caption)
                        Text("開始日期：\(formatted(date))")
                            .font(.subheadline)
                    }
                    .foregroundColor(.gray)
                }

                // User ID
                if let userId = user?.userId {
                    HStack {
                        Text("ID")
                            .font(.caption)
                            .foregroundColor(.gray)

                        Text(userId)
                            .font(.subheadline)
                            .monospacedDigit()

                        Spacer()

                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 16)
        }
        .background(Color.white)
    }

    // MARK: - Background
    private var headerBackground: some View {
        Image("TOH") // 可換成 EKITAG pattern
            .resizable()
            .scaledToFill()
            .clipped()
    }

    // MARK: - Profile Image (顯示用)
    @ViewBuilder
    private var profileImage: some View {
        if
            let urlString = user?.profileImagePathUrl,
            let url = URL(string: urlString)
        {
            AsyncImage(url: url) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 88, height: 88)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white, lineWidth: 3)
            )
            .shadow(radius: 6)

        } else {
            Image(systemName: "person.fill")
                .font(.system(size: 36))
                .foregroundColor(.gray)
                .frame(width: 88, height: 88)
                .background(Color(.systemGray5))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white, lineWidth: 3)
                )
                .shadow(radius: 6)
        }
    }

    private func formatted(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: date)
    }
}
