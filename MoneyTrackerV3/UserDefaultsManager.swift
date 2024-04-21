//
//  UserDefaultsManager.swift
//  MoneyTrackerV3
//
//  Created by Wares on 21/02/2024.
//

import Foundation

// Storage solution I opted for in my app
struct UserDefaultsManager {
    static let friendsKey = "friends"

    static func loadFriends() -> [Friend]? {
        if let data = UserDefaults.standard.data(forKey: friendsKey) {
            do {
                let decoder = JSONDecoder()
                return try decoder.decode([Friend].self, from: data)
            } catch {
                print("Error decoding friends data: \(error.localizedDescription)")
                return nil
            }
        }
        return nil
    }

    // Create new JSONEncoder object
    // Encodes friends array
    // Uses UserDefaults and saves data with a key to easily store and retrieve later
    static func saveFriends(_ friends: [Friend]) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(friends)
            UserDefaults.standard.set(data, forKey: friendsKey)
        } catch {
            print("Error encoding friends data: \(error.localizedDescription)")
        }
    }
}

