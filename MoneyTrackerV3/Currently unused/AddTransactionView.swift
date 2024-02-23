//
//  AddTransactionView.swift
//  MoneyTrackerV3
//
//  Created by Wares on 23/02/2024.
//

import Foundation
import SwiftUI

struct AddTransactionView: View {
    @Binding var friend: Friend
    @ObservedObject var friendsViewModel: FriendsViewModel
    @State private var newTransactionAmount = ""
    @State private var selectedTransactionType = TransactionType.lend
    @State private var isShowingError = false
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Add Transaction")
                .font(.title)
                .bold()

            TextField("Enter amount", text: $newTransactionAmount)
                .keyboardType(.decimalPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Picker("Type", selection: $selectedTransactionType) {
                Text("Lend").tag(TransactionType.lend)
                Text("Borrow").tag(TransactionType.borrow)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            Button("Add Transaction") {
                guard let amount = Double(newTransactionAmount), amount > 0 else {
                    isShowingError = true
                    return
                }

                let newTransaction = Transaction(id: UUID(), friend: friend.id, amount: amount, type: selectedTransactionType, date: Date())
                friend.transactions.append(newTransaction)
                friendsViewModel.saveFriends()

                // Reset input fields
                newTransactionAmount = ""
                selectedTransactionType = .lend

                // Dismiss the sheet
                presentationMode.wrappedValue.dismiss()
            }
            .foregroundColor(.white)
            .padding()
            .background(Color.blue)
            .cornerRadius(8)
        }
        .padding()
        .navigationTitle("Add Transaction")
        .alert(isPresented: $isShowingError) {
            Alert(
                title: Text("Error"),
                message: Text("Please enter a valid positive number for the transaction amount."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}
