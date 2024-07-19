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
    
    var netBalance: Double {
        return totalLend - totalBorrow
    }
    
    // Calculating historical transaction data for overview of past totalLend and totalBorrow values on a chart
    func historicalData() -> [(date: Date, totalLend: Double, totalBorrow: Double)] {
        let calendar = Calendar.current
        var history: [(date: Date, totalLend: Double, totalBorrow: Double)] = []

        for transaction in transactions {
            let date = calendar.startOfDay(for: transaction.date)
            if let index = history.firstIndex(where: { $0.date == date }) {
                if transaction.type == .lend {
                    history[index].totalLend += transaction.amount
                } else {
                    history[index].totalBorrow += transaction.amount
                }
            } else {
                let totalLend = transaction.type == .lend ? transaction.amount : 0
                let totalBorrow = transaction.type == .borrow ? transaction.amount : 0
                history.append((date: date, totalLend: totalLend, totalBorrow: totalBorrow))
            }
        }

        // Sort the history by date for easy charting
        history.sort { $0.date < $1.date }
        return history
    }
}
