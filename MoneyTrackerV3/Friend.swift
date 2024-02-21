//
//  Friend.swift
//  MoneyTrackerV3
//
//  Created by Wares on 21/02/2024.
//

import Foundation

struct Friend: Identifiable, Codable {
    let id: UUID
    let name: String
    var transactions: [Transaction]

    var totalLend: Double {
        transactions.filter { $0.type == .lend }.map { $0.amount }.reduce(0, +)
    }

    var totalBorrow: Double {
        transactions.filter { $0.type == .borrow }.map { $0.amount }.reduce(0, +)
    }
}
