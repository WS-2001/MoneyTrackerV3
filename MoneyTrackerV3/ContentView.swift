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
    @State private var isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
    
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
                generateHapticFeedback(style: .light)
            } else if newTab == .settings {
                generateHapticFeedback(style: .light)
            }
        }
//    .environment(\.colorScheme, isDarkMode ? .dark : .light)
    .preferredColorScheme(isDarkMode ? .dark : .light)
    }
    
    private func generateHapticFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
    }
}

#Preview {
    ContentView()
}
