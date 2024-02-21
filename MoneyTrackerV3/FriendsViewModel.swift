//
//  FriendsViewModel.swift
//  MoneyTrackerV3
//
//  Created by Wares on 21/02/2024.
//
import SwiftUI
import Foundation

class FriendsViewModel: ObservableObject {
    @Published var friends: [Friend] = []

    init() {
        loadFriends()
    }

    func loadFriends() {
        if let savedFriends = UserDefaultsManager.loadFriends() {
            friends = savedFriends
        } else {
            // Default for testing
            friends = [
                Friend(id: UUID(), name: "Muhima", transactions: []),
                Friend(id: UUID(), name: "Samira", transactions: [])
            ]
        }
    }

    func saveFriends() {
        UserDefaultsManager.saveFriends(friends)
    }

    func addFriend(name: String) {
        let newFriend = Friend(id: UUID(), name: name, transactions: [])
        friends.append(newFriend)
        saveFriends()
    }

    // NEED TO:
    // ADD A REMOVE FUNCTION (lol add a remove)
}
