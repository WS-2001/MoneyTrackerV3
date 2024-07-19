//
//  HistoricalDataView.swift
//  MoneyTrackerV3
//
//  Created by Wares on 19/07/2024.
//

import Foundation
import SwiftUI
import SwiftUICharts

struct HistoricalDataView: View {
    let historicalData: [(date: Date, totalLend: Double, totalBorrow: Double)]
    
    @State private var typeOfTotal: DataSeries = .totalLend
    
    enum DataSeries: String, CaseIterable, Identifiable {
        case totalLend = "Total Lend"
        case totalBorrow = "Total Borrow"
        
        var id: String { rawValue }
    }
    
    private var dates: [String] {
        historicalData.map { dateFormatter.string(from: $0.date) }
    }
    
    private var dataPoints: [Double] {
        switch typeOfTotal {
        case .totalLend:
            return historicalData.map { $0.totalLend }
        case .totalBorrow:
            return historicalData.map { $0.totalBorrow }
        }
    }
    
    var body: some View {
        // If no data, then display message
        if historicalData.isEmpty {
            Text("No historical data available 🧐")
                .font(.headline)
                .foregroundColor(.gray)
                .padding()
        }
        else {
            VStack {
                // Select type of total
                Picker("Type of Total", selection: $typeOfTotal) {
                    ForEach(DataSeries.allCases) { series in
                        Text(series.rawValue).tag(series)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                // Line chart based on selected type of total
                VStack {
                    LineView(
                        data: dataPoints, title: typeOfTotal.rawValue, style: Styles.lineChartStyleOne, valueSpecifier: "%.2f")
                    .frame(height: 300)
                    
                    // Date labels for better overview
                    HStack(spacing: 10) {
                        ForEach(dates.indices, id: \.self) { index in
                            Text(dates[index])
                                .font(.caption)
                                .foregroundColor(.gray)
                                .frame(width: 40, height: 60)
                                .rotationEffect(.degrees(-45))
                                .padding(.bottom, 5)
                        }
                    }
                    .padding(.top, 30)
                }
                .padding()
            }
            .navigationTitle("Historical Data")
        }
    }
    
    // Format date to specific format for spacing issues
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return formatter
    }
}
