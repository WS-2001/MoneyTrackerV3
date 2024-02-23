//
//  EditNoteView.swift
//  MoneyTrackerV3
//
//  Created by Wares on 23/02/2024.
//

import SwiftUI

struct EditNoteView: View {
    @Binding var isEditingNote: Bool
    @Binding var note: String
    var onSave: (String) -> Void
    var friendsViewModel: FriendsViewModel

    var body: some View {
        NavigationView {
            VStack {
                Text("Edit Note")
                    .font(.title)
                    .padding()

                TextEditor(text: $note)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)

                Button("Save") {
                    onSave(note)
                    isEditingNote = false
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(8)
            }
            .padding()
            .navigationTitle("Edit Note")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isEditingNote = false
                    }
                }
            }
        }
        .environment(\.colorScheme, UserDefaults.standard.bool(forKey: "isDarkMode") ? .dark : .light)
    }
}
