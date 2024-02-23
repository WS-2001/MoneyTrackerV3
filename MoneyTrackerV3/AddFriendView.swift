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
        NavigationView {
            VStack {
                Spacer()

                Image(systemName: "person.crop.circle.fill.badge.plus")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    .foregroundColor(Color.blue)

                Text("Add a Friend")
                    .font(.title)
                    .padding()

                TextField("Enter friend's name", text: $newFriendName)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onAppear {
                        DispatchQueue.main.async {
                            UIApplication.shared.sendAction(#selector(UIResponder.becomeFirstResponder), to: nil, from: nil, for: nil)
                        }
                    }

                Button(action: {
                    if newFriendName.isEmpty {
                        isShowingError = true
                    } else {
                        friendsViewModel.friends.append(Friend(id: UUID(), name: newFriendName, transactions: []))
                        friendsViewModel.saveFriends()
                        newFriendName = ""
                        isPresented = false
                    }
                }) {
                    Text("Add Friend")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()

                Spacer()

            }
            .padding()
            .background(isDarkMode ? Color.black : Color.white)
            .preferredColorScheme(isDarkMode ? .dark : .light)
            .navigationBarItems(leading: Button("Cancel") {
                isPresented = false
            })
        }
        .alert(isPresented: $isShowingError) {
            Alert(
                title: Text("Error"),
                message: Text("Your friend is a mysterious person... Please enter a name."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}
