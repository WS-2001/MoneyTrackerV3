//
//  SettingsView.swift
//  MoneyTrackerV3
//
//  Created by Wares on 21/02/2024.
//

import Foundation
import SwiftUI

struct SettingsView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false

    var body: some View {
        Form {
            
            //About
            Section() {
                            NavigationLink(destination: AboutView()) {
                                Text("About")
                            }
                        }
            
            //Dark Mode
            Section(header: Text("Appearance")) {
                Toggle("Dark Mode", isOn: $isDarkMode)
                    .onChange(of: isDarkMode) { newValue in
                        print("Dark Mode changed to \(newValue)")
                        UserDefaults.standard.set(newValue, forKey: "isDarkMode")
                        updateAppearanceMode(newValue)
                    }
            }
        }
        .navigationTitle("Settings")
    }

    private func updateAppearanceMode(_ isDarkMode: Bool) {
        UIApplication.shared.windows.first?.rootViewController?.overrideUserInterfaceStyle = isDarkMode ? .dark : .light
    }
}
