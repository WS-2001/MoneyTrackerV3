//
//  FriendView.swift
//  MoneyTrackerV3
//
//  Created by Wares on 21/02/2024.
//
import SwiftUI

struct FriendsView: View {
    @ObservedObject var friendsViewModel: FriendsViewModel
    @Binding var newFriendName: String
    @State private var isShowingError = false
    @State private var isAddFriendSheetPresented = false
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(friendsViewModel.friends) { friend in
                        NavigationLink(
                            destination: FriendDetailView(
                                friend: $friendsViewModel.friends[getIndex(for: friend)],
                                friendsViewModel: friendsViewModel
                            )
                        ) {
                            VStack(alignment: .leading) {
                                HStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .frame(width: 30, height: 30)
                                        .overlay(
                                            Text(String(friend.name.prefix(1)))
                                                .font(.subheadline)
                                                .foregroundColor(Color("Initial"))
                                        )
                                    Text(friend.name)
                                        .font(.headline)
                                    Spacer()
                                    VStack(alignment: .trailing) {
                                        Text("Lent: £\(friend.totalLend, specifier: "%.2f")")
                                            .font(.subheadline)
                                            .foregroundColor(.green)
                                        Text("Borrowed: £\(friend.totalBorrow, specifier: "%.2f")")
                                            .font(.subheadline)
                                            .foregroundColor(.red)
                                    }
                                }
                            }
                        }
                    }
                    .onDelete { indexSet in
                        friendsViewModel.friends.remove(atOffsets: indexSet)
                        friendsViewModel.saveFriends()
                    }

                }
                Spacer() // Add Spacer to push the button to the bottom

                Button(action: {
                    isAddFriendSheetPresented = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(Color.blue)
                    
                    Text("Add Friend")
                        .font(.headline)
                        .foregroundColor(Color.blue)
                }
                .padding()
                .background(Color.clear)
                .cornerRadius(20)
                .sheet(isPresented: $isAddFriendSheetPresented) {
                    AddFriendView(isPresented: $isAddFriendSheetPresented, friendsViewModel: friendsViewModel, newFriendName: $newFriendName)
                }
            }
        }
        .navigationTitle("Money Tracker")
    }
    private func getIndex(for friend: Friend) -> Int {
        guard let index = friendsViewModel.friends.firstIndex(where: { $0.id == friend.id }) else {
            fatalError("Friend not found in the array")
        }
        return index
    }
    
    private func addNewFriend() {
        friendsViewModel.friends.append(Friend(id: UUID(), name: newFriendName, transactions: []))
        friendsViewModel.saveFriends()
        newFriendName = ""
    }
}
