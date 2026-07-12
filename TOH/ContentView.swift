//
//  ContentView.swift
//  TOH
//
//  Created by Alia on 2025/1/15.
//

import SwiftUI

enum Tab {
  case home, saved, add, explore, account
 }

//an enum for each Tab that tracks the views of the Tab
enum HomeNavigation: Hashable {
 case child, secondChild, thirdChild
}

struct ContentView: View {
    @State private var showSignIn = false
    
    @EnvironmentObject var userSession: UserSession
    
    @State private var selectedTab: Tab = .home
    
    //Declare navigationStacks for each of the tabs
    @State private var homeNavigationStack: [HomeNavigation] = []
    //@State private var savedNavigationStack: [SavedNavigation] = []
    //@State private var addNavigationStack: [AddNavigation] = []
    //@State private var exploreNavigationStack: [ExploreNavigation] = []
    //@State private var accountNavigationStack: [AccountNavigation] = []
    
    //@Binding var showSignInView: Bool
    
    var body: some View {
        //NavigationStack(path: $homeNavigationStack){
            TabView(selection: tabSelection()){
                
                HomepageView(path: $homeNavigationStack).tabItem {
                    Image(systemName: "house")
                    Text("Home")
                    }
                .tag(Tab.home)
                //.badge(1)
                
                FavoritesView().tabItem {
                    Image(systemName: "heart")
                    Text("Saved")
                }
                .tag(Tab.saved)
                
                StoryView().tabItem{
                    Image(systemName: "plus.square")
                    Text("Add")
                }
                .tag(Tab.add)
                
                ExploreView().tabItem {
                    Image(systemName: "location.magnifyingglass")
                    Text("Explore")
                    }
                .tag(Tab.explore)
                
                ProfileView_v2().tabItem {
                    Image(systemName: "person.circle")
                    Text("Account")
                    }
                .tag(Tab.account)
                
            }
            .accentColor(.myGreen2)
            .background(Color.myBackground)
            .fullScreenCover(isPresented: $showSignIn) {
                NavigationStack {
                    AuthenticationView(allowGuest: false)
                        .environmentObject(userSession)
                }
            }
        }
        
        
    //}
}
extension ContentView {
    
    private func tabSelection() -> Binding<Tab> {
        Binding { //this is the get block
            self.selectedTab
        } set: { tappedTab in
            if tappedTab == self.selectedTab {
                //User tapped on the tab twice == Pop to root view
                if homeNavigationStack.isEmpty {
                    //User already on home view, scroll to top
                } else {
                    homeNavigationStack = []
                }
            }
            //Set the tab to the tabbed tab
            if tappedTab == .account && !userSession.isSignedIn {
                // 想切到 Account，但還沒登入，強制跳出登入頁，並不切換 tab
                showSignIn = true
                // 不改變 selectedTab，保持在原本 tab
            } else {
                // 正常切換 tab
                self.selectedTab = tappedTab
            }
        }
    }
}

