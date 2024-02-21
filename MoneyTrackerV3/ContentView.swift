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
                // Do something when switching to the Friends tab
            } else if newTab == .settings {
                // Do something when switching to the Settings tab
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct FriendsView: View {
    @ObservedObject var friendsViewModel: FriendsViewModel
    @Binding var newFriendName: String

    var body: some View {
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
                                            .foregroundColor(.white)
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

            HStack {
                TextField("Enter friend's name", text: $newFriendName)
                Button("Add Friend") {
                    friendsViewModel.friends.append(Friend(id: UUID(), name: newFriendName, transactions: []))
                    friendsViewModel.saveFriends()
                    newFriendName = ""
                }
            }
            .padding()
            .textFieldStyle(RoundedBorderTextFieldStyle())
        }
        .navigationTitle("Money Tracker")
    }

    private func getIndex(for friend: Friend) -> Int {
        guard let index = friendsViewModel.friends.firstIndex(where: { $0.id == friend.id }) else {
            fatalError("Friend not found in the array")
        }
        return index
    }
}

struct SettingsView: View {
    var body: some View {
        Text("Settings Content Goes Here")
            .navigationTitle("Settings")
    }
}

#Preview {
    ContentView()
}
