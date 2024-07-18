//
//  TotalChartView.swift
//  MoneyTrackerV3
//
//  Created by Wares on 19/04/2024.
//

import Foundation
import SwiftUI
import SwiftUICharts

struct TotalChartView: View {
    let friends: [Friend]
    
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    // Total chart in home screen
    var body: some View {
        VStack {
            PieChartView(data: [totalLent,totalBorrowed], title: (String(format: "Total Lent: %.2f\nTotal Borrowed: %.2f", totalLent, totalBorrowed)), form: ChartForm.large, dropShadow: false, valueSpecifier: "%.2f")
        }
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
