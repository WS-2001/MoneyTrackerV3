//
//  Transaction.swift
//  MoneyTrackerV3
//
//  Created by Wares on 21/02/2024.
//
import Foundation

struct Transaction: Identifiable, Codable {
    let id: UUID
    let friend: UUID  // Had to change friendID to friend due to ContentView ._.
    let amount: Double
    let type: TransactionType
    let date: Date
    var note: String?
}
