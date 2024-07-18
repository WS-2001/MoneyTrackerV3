//
//  AboutView.swift
//  MoneyTrackerV3
//
//  Created by Wares on 22/02/2024.
//

import Foundation
import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack {
            Text("Money Tracker")
                .font(.title)
                .padding()
                .bold()

            Text("Money Tracker is an app that helps you keep track of the money you borrowed and lent to friends. It's simple to use, leveraging Apple's design language to ensure it stays consistent with other apps you may use.\n\nTip: to remove any fields, you can swipe the field to the left, just like any Apple app!")
                .font(.body)
                .padding()
            
            Text("Currency conversion powered by ExchangeRate-API through their API interface.\n\nCharts powered by a modified version of SwiftUICharts by Andras Samu.")
                .font(.body)
                .padding()
            
            Text("Version 1.1")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            HStack 
            {
                Text("Built by Wares Sadat")
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            Spacer()
        }
        .navigationTitle("About")
    }
}
