//
//  ContentView.swift
//  MoneyTrackerV3
//
//  Created by Wares on 21/02/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var friendsViewModel = FriendsViewModel()
    @State private var newFriendName = ""
    @State private var selectedTab: Tab = .friends
    
    enum Tab {
        case friends, settings
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationView {
                FriendsView(friendsViewModel: friendsViewModel, newFriendName: $newFriendName)
            }
            .tabItem {
                Label("Friends", systemImage: "person.2")
            }
            .tag(Tab.friends)

            NavigationView {
                SettingsView()
            }
            .tabItem {
                Label("Settings", systemImage: "gearshape")
            }
            .tag(Tab.settings)
        }
        .onChange(of: selectedTab) { newTab in
            if newTab == .friends {
                // Do something when switching to the Friends tab
            } else if newTab == .settings {
                // Do something when switching to the Settings tab
            }
        }
    }
}

#Preview {
    ContentView()
}
