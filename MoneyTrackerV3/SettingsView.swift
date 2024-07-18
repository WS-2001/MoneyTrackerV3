//
//  SettingsView.swift
//  MoneyTrackerV3
//
//  Created by Wares on 21/02/2024.
//

import Foundation
import SwiftUI

struct SettingsView: View {
    @ObservedObject var friendsViewModel: FriendsViewModel

    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("notePreviewLines") private var notePreviewLines = 3
    @AppStorage("noteEditingSymbol") private var noteEditingSymbol = "pencil.circle"
    @AppStorage("showCharts") private var showCharts = true
    @AppStorage("showTotalChart") private var showTotalChart = true
    @AppStorage("enableNoteEditingIcon") private var enableNoteEditingIcon = true

    var body: some View {
        Form {
            
            //About and Help
            Section() {
                NavigationLink(destination: AboutView()) {
                    Text("About")
                }
                NavigationLink(destination: HelpView()) {
                    Text("Help")
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
            
            // Charts
            Section(header: Text("Charts")) {
                Toggle("Show 'Future Net Balance Prediction' Charts for Friends", isOn: $showCharts)
                    .onChange(of: showCharts) { newValue in
                        UserDefaults.standard.set(newValue, forKey: "showCharts")
                    }
                
                Text("If enabled, a chart will show at the top of a friend's transaction list showing what your future net balance could look like, utilising a fully trained model.")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Toggle("Show Total Chart", isOn: $showTotalChart)
                    .onChange(of: showTotalChart) { newValue in
                        UserDefaults.standard.set(newValue, forKey: "showTotalChart")
                    }
                
                Text("If enabled, a chart will show at the top of the Friends home page with the total lend and borrow amounts.")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            // Editing Icon
            Section(header: Text("Edit Icon")){
                // Toggle for Note Editing Icon, if on, display and allow below
                Toggle("Enable Edit Icon", isOn: $enableNoteEditingIcon)
                
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
                .disabled(!enableNoteEditingIcon) // If Toggle is off, disable
                .foregroundColor(enableNoteEditingIcon ? .primary : .gray) // If toggle is off, make it grey to signify that it is not available
                .onChange(of: noteEditingSymbol) { newValue in
                    handleHapticFeedback()
                }
            }
            
            // Delete All Data
            Section(header: Text("DANGER AREA")) {
                NavigationLink(destination: DeleteAllDataView(friendsViewModel: friendsViewModel)) {
                    Text("Delete All Data...")
                        .foregroundColor(.red)
                }
            }
        }
        .navigationTitle("Settings")
    }

    // For Dark/Light mode setting
    private func updateAppearanceMode(_ isDarkMode: Bool) {
        UIApplication.shared.windows.first?.rootViewController?.overrideUserInterfaceStyle = isDarkMode ? .dark : .light
    }
    
    // Haptic feedback generator
    private func handleHapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
}
