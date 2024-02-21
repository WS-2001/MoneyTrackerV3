//
//  MoneyTrackerV3App.swift
//  MoneyTrackerV3
//
//  Created by Wares on 21/02/2024.
//

import SwiftUI

@main
struct MoneyTrackerV3App: App {
    @AppStorage("isDarkMode") private var isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")

    init() {
        // Initialize UserDefaults and set default values
        UserDefaults.standard.register(defaults: ["isDarkMode": isDarkMode])
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.colorScheme, isDarkMode ? .dark : .light)
            // The extra environment and initilisation lines ensure that if dark mode was previously selected, it stays so during initilisation and startup
        }
    }
}
