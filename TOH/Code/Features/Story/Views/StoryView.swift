//
//  StoryView.swift
//  TOH
//
//  Created by Alia on 2025/3/14.
//
import SwiftUI
import FirebaseAnalytics

struct StoryView: View {

    @StateObject private var viewModel = StoryViewModel()
    @EnvironmentObject var userSession: UserSession

    @State private var showSignIn = false

    var body: some View {

        NavigationStack {

            ZStack {

                // MARK: - Feed

                Group {

                    if viewModel.isLoading {

                        VStack {
                            Spacer()

                            ProgressView()

                            Spacer()
                        }

                    } else if viewModel.posts.isEmpty {

                        VStack(spacing: 12) {

                            Image(systemName: "photo.on.rectangle")
                                .font(.system(size: 40))

                            Text("No Stories Yet")
                                .font(.headline)

                        }
                        .foregroundStyle(.gray)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)

                    } else {

                        ScrollView {

                            LazyVStack(spacing: 20) {

                                ForEach(viewModel.posts, id: \.id) { post in

                                    PostCellViewBuilder(post: post)

                                }
                            }
                            .padding(.vertical)
                        }
                    }
                }

                // MARK: - Floating Button

                VStack {

                    Spacer()

                    HStack {

                        Spacer()

                        Button {

                            if userSession.isSignedIn {
                                viewModel.createPost = true
                            } else {
                                showSignIn = true
                            }

                        } label: {

                            Image(systemName: "plus")
                                .font(.title2.bold())
                                .foregroundStyle(.white)
                                .padding()
                                .background(Color.myGreen2, in: Circle())
                                .shadow(radius: 5)
                        }
                        .padding()
                    }
                }

                // MARK: - Reward Dialog

                if viewModel.showResultDialog {

                    ZStack {

                        Color.black.opacity(0.4)
                            .ignoresSafeArea()

                        VStack(spacing: 16) {

                            if let stamp = viewModel.earnedStamp {

                                Text("獲得印章！🎉")
                                    .font(.title2.bold())

                                Image(stamp)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)

                                Text(stamp)
                                    .font(.headline)

                            } else if let message = viewModel.earnedPointMessage {

                                Text("謝謝你在拉麵的貢獻")
                                    .font(.title2.bold())

                                Text(message)
                                    .multilineTextAlignment(.center)
                            }

                            Button("確認") {
                                viewModel.resetResultState()
                            }
                            .padding(.top, 8)
                        }
                        .padding()
                        .frame(maxWidth: 300)
                        .background(.regularMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                }
            }
            .navigationTitle("Stories")
        }

        // MARK: - Lifecycle

        .onAppear {

            viewModel.observePosts() //即時同步

            Analytics.logEvent(
                AnalyticsEventScreenView,
                parameters: [
                    AnalyticsParameterScreenName: "StoryView",
                    AnalyticsParameterScreenClass: "StoryView"
                ]
            )
        }
        .onDisappear {
            viewModel.stopObservingPosts()
        }

        // MARK: - Create Post

        .fullScreenCover(isPresented: $viewModel.createPost) {

            CreatePostView()
                .overlay {

                    if viewModel.isWriting {

                        ZStack {

                            Color.black.opacity(0.2)
                                .ignoresSafeArea()

                            ProgressView()
                        }
                    }
                }
                .environmentObject(viewModel)
        }

        // MARK: - Sign In

        .fullScreenCover(isPresented: $showSignIn) {

            NavigationStack {

                AuthenticationView(allowGuest: false)
                    .environmentObject(userSession)
            }
        }
    }
}

#Preview {
    StoryView()
}
