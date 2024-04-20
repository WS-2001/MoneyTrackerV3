//
//  FriendsViewModel.swift
//  MoneyTrackerV3
//
//  Created by Wares on 21/02/2024.
//
import SwiftUI
import Foundation

class FriendsViewModel: ObservableObject {
    @Published var isDarkMode: Bool = false
    @Published var friends: [Friend] = []

    init() {
        loadFriends()
        loadDarkModeSetting()
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
    
    // Load Dark Mode setting from UserDefaults
    func loadDarkModeSetting() {
        if let isDarkModeSetting = UserDefaults.standard.value(forKey: "isDarkMode") as? Bool {
            isDarkMode = isDarkModeSetting
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
    
    // CLEAR ALL DATA
    func deleteAllData() {
        friends.removeAll()
        saveFriends()
    }
}
