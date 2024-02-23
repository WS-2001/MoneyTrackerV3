//
//  AddFriendView.swift
//  MoneyTrackerV3
//
//  Created by Wares on 21/02/2024.
//

import Foundation
import SwiftUI

struct AddFriendView: View {
    @Binding var isPresented: Bool
    @ObservedObject var friendsViewModel: FriendsViewModel
    @Binding var newFriendName: String
    @Binding var isDarkMode: Bool
    @State private var isShowingError = false
    
    var body: some View {
        NavigationView
        {
            VStack {                
                Text("Add Friend")
                    .font(.title)
                    .padding()
                
                TextField("Enter friend's name", text: $newFriendName)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button("Save") {
                    if newFriendName.isEmpty {
                        isShowingError = true
                    } else {
                        friendsViewModel.friends.append(Friend(id: UUID(), name: newFriendName, transactions: []))
                        friendsViewModel.saveFriends()
                        newFriendName = ""
                        isPresented = false
                    }
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(10)
                .padding()
                .alert(isPresented: $isShowingError) {
                    Alert(
                        title: Text("Error"),
                        message: Text("Your friend is a mysterious person... Please enter a name."),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
            .preferredColorScheme(isDarkMode ? .dark : .light)
            .navigationBarItems(leading: Button("Cancel") {
                isPresented = false
            })
        }
//        .preferredColorScheme(friendsViewModel.isDarkMode ? .dark : .light) // Set the color scheme based on the user's setting
    }
}
