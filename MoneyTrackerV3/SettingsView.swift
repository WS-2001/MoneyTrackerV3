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
    @AppStorage("notePreviewLines") private var notePreviewLines = 3
    @AppStorage("noteEditingSymbol") private var noteEditingSymbol = "pencil.circle"

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
            
            // Note Preview
            Section(header: Text("Note Preview")) {
                Stepper("Number of Lines: \(notePreviewLines)", value: $notePreviewLines, in: 1...10)
                    .onChange(of: notePreviewLines) { newValue in
                        print("Note Preview: \(newValue)")
                        handleHapticFeedback()
                        UserDefaults.standard.set(newValue, forKey: "notePreviewLines")
                    }
                
                Text("Adjust the number of lines displayed in the note preview before it truncates the rest.")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            // Editing Icon
            Section(header: Text("Note Editing Icon")){
                Picker(selection: $noteEditingSymbol, label: Text("Select Icon")) {
                    Image(systemName: "pencil.circle")
                        .tag("pencil.circle")
                        .padding()
                    
                    Image(systemName: "righttriangle.fill")
                        .tag("righttriangle.fill")
                        .padding()
                    
                    Image(systemName: "note.text")
                        .tag("note.text")
                        .padding()
                    
                    Image(systemName: "arrow.right.circle")
                        .tag("arrow.right.circle")
                        .padding()
                    
                    Image(systemName: "arrow.up.left.and.arrow.down.right")
                        .tag("arrow.up.left.and.arrow.down.right")
                        .padding()
                }
                .pickerStyle(SegmentedPickerStyle())
                .onChange(of: noteEditingSymbol) { newValue in
                    handleHapticFeedback()
                }
            }
        }
        .navigationTitle("Settings")
    }

    private func updateAppearanceMode(_ isDarkMode: Bool) {
        UIApplication.shared.windows.first?.rootViewController?.overrideUserInterfaceStyle = isDarkMode ? .dark : .light
    }
    
    private func handleHapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
}
