//
//  TotalChartView.swift
//  MoneyTrackerV3
//
//  Created by Wares on 19/04/2024.
//

import Foundation
import SwiftUI
import Charts

struct TotalChartView: View {
    let friends: [Friend]
    
    // Total chart in home screen
    var body: some View {
        Chart {
            BarMark(
                x: .value("Amount", totalLent),
                y: .value("Type", String(format: "Lent £%.2f", totalLent)) // Display with 2dp
            )
            .foregroundStyle(.green)
            
            BarMark(
                x: .value("Amount", totalBorrowed),
                y: .value("Type", String(format: "Borrowed £%.2f", totalBorrowed)) // Display with 2dp
            )
            .foregroundStyle(.red)
        }
        .frame(height: 120)
    }
    
    // Calculate totalLent and totalBorrowed from all friends
    // Iterates over each friend and maps total
    // Array of total amounts gets accumulated with reduce with initial value 0
    private var totalLent: Double {
        friends.map { $0.totalLend }.reduce(0, +)
    }
    
    private var totalBorrowed: Double {
        friends.map { $0.totalBorrow }.reduce(0, +)
    }
}
