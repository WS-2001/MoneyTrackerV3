//
//  HelpView.swift
//  MoneyTrackerV3
//
//  Created by Wares on 19/04/2024.
//

import Foundation
import SwiftUI

struct HelpView: View {
    var body: some View {
        Form {
            Section(header: Text("Introduction")) {
                Text("Welcome to Money Tracker! This app is designed to help you track your financial transactions with friends and family.")
            }

            Section(header: Text("Getting Started")) {
                Text("• Add each friend as an entry to track who you borrow from and lend money to. Afterwards, you can tap on each friend to add transactions to their entry.")
                Text("• View how much you owe and have lent in total on the home page. This can be turned off in the Settings.")
                Text("• There's a chart on each friend's page to quickly get an overview for that friend. This can be turned off in the Settings.")
                Text("• Edit (by tapping) or delete transactions (by swiping) as needed. The editing icon can be changed in the Settings.")
                Text("• Prefer things dark? There's a Dark mode option in the Settings.")
            }
        }
        .navigationTitle("Help")
    }
}
