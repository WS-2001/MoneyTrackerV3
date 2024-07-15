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
    
    // Tabs
    enum Tab {
        case friends, settings, convert
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            // Navigation Tabs
            
            // Friends Tab
            NavigationView {
                FriendsView(friendsViewModel: friendsViewModel, newFriendName: $newFriendName)
            }
            .tabItem {
                Label("Friends", systemImage: "person.2")
            }
            .tag(Tab.friends)
            
            // Currency Conversion Tab
            NavigationView {
                ExchangeRateView()
            }
            .tabItem {
                Label("Convert", systemImage: "sterlingsign.circle")
            }
            .tag(Tab.convert)

            // Settings Tab
            NavigationView {
                SettingsView(friendsViewModel: friendsViewModel)
            }
            .tabItem {
                Label("Settings", systemImage: "gearshape")
            }
            .tag(Tab.settings)
        }
        // New tab selection generates haptic feedback
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
    
    // Helper function to generate haptic feedback based on argument
    private func generateHapticFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
    }
}

#Preview {
    ContentView()
}
