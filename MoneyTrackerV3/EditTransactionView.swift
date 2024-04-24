//
//  EditNoteView.swift
//  MoneyTrackerV3
//
//  Created by Wares on 23/02/2024.
//

import SwiftUI

struct EditTransactionView: View {
    @Binding var transaction: Transaction
    @ObservedObject var friendsViewModel: FriendsViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var amountString: String = ""
    @State private var originalTransaction: Transaction
    
    // To ensure 'cancel' button reverts transaction and doesn't change it needlessly
    init(transaction: Binding<Transaction>, friendsViewModel: FriendsViewModel) {
            self._transaction = transaction
            self._originalTransaction = State(initialValue: transaction.wrappedValue)
            self.friendsViewModel = friendsViewModel
            
            _amountString = State(initialValue: String(format: "%.2f", transaction.wrappedValue.amount))
        }
    
    var body: some View {
        NavigationView {
            Form {
                // Editing amount of transaction
                // Needed to add .onChangeOf bit as the 2dp didn't show up after the significant figure amount (e.g. .00)
                Section(header: Text("Amount")) {
                    TextField("Amount", text: $amountString)
                        .keyboardType(.decimalPad)
                        .onChange(of: amountString) { newValue in
                            transaction.amount = Double(newValue) ?? 0.0
                        }
                }

                // Editing type of transaction
                // Lend or Borrow
                Section(header: Text("Type")) {
                    Picker("Transaction Type", selection: $transaction.type) {
                        Text("Lend").tag(TransactionType.lend)
                        Text("Borrow").tag(TransactionType.borrow)
                    }
                }

                // Editing date and time of transaction
                Section(header: Text("Date")) {
                    DatePicker("Date and Time", selection: $transaction.date, displayedComponents: [.date, .hourAndMinute])
                }

                // Editing note of transaction
                // Binding was required due to UUID not working previously to change a note. This ensures it's the correct transaction being changed.
                Section(header: Text("Note")) {
                    TextEditor(text: Binding(
                        get: { transaction.note ?? "" },
                        set: { transaction.note = $0.isEmpty ? nil : $0 }
                    ))
                }
            }
            .navigationBarTitle("Edit Transaction", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        friendsViewModel.saveFriends()
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        transaction = originalTransaction // Cancel
                        dismiss()
                    }
                }
            }
            .environment(\.colorScheme, UserDefaults.standard.bool(forKey: "isDarkMode") ? .dark : .light)
            // Below is for the 2dp format in amount text field
            .onAppear {
                amountString = String(format: "%.2f", transaction.amount)
            }
        }
    }
}
