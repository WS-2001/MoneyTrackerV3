//
//  SplitBillView.swift
//  MoneyTrackerV3
//
//  Created by Wares on 16/07/2024.
//
import Foundation
import SwiftUI

struct SplitBillView: View {
    @ObservedObject var friendsViewModel: FriendsViewModel
    @Binding var isPresented: Bool // Binding to dismiss sheet once done
    @Binding var isDarkMode: Bool
    
    @State private var isShowingError = false
    @State private var totalAmountString: String = ""
    @State private var selectedFriends: [UUID] = []
    @State private var note: String = ""
    @State private var selectedTransactionType: TransactionType = .lend
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("How it works")) {
                        Text("Enter the bill amount and select the friends involved. Optionally add a note. This will give each friend a separate transaction with type selected and splits the amount equally.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    Section(header: Text("Total Amount")) {
                        TextField("Total Amount", text: $totalAmountString)
                            .keyboardType(.decimalPad)
                    }
                    
                    Section(header: Text("Note")) {
                        TextField("(Optional)", text: $note)
                    }
                    
                    Section(header: Text("Select Transaction Type")) {
                        Picker("Type", selection: $selectedTransactionType) {
                            Text("Lend").tag(TransactionType.lend)
                            Text("Borrow").tag(TransactionType.borrow)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        Text("Did you pay for them? Pick lend. \nDid they pay for you? Pick borrow.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    Section(header: Text("Select Friends")) {
                        List(friendsViewModel.friends) { friend in
                            MultipleSelectionRow(friend: friend, isSelected: self.selectedFriends.contains(friend.id)) {
                                if self.selectedFriends.contains(friend.id) {
                                    self.selectedFriends.removeAll { $0 == friend.id }
                                } else {
                                    self.selectedFriends.append(friend.id)
                                }
                            }
                        }
                    }
                    
                }
                .background(isDarkMode ? Color.black : Color.white)
                .preferredColorScheme(isDarkMode ? .dark : .light)
                .navigationBarItems(leading: Button("Cancel") {
                    isPresented = false
                }, trailing: Button("Split Bill") {
                    if selectedFriends.isEmpty {
                        print("None selected") // Debug
                        isShowingError = true
                    } else {
                        if let totalAmount = Double(totalAmountString) {
                            splitBill(totalAmount: totalAmount)
                            isPresented = false // Dismiss sheet after splitting bill
                        }
                    }
                })
            }
        }
        // Error for input validation
        .alert(isPresented: $isShowingError) {
            Alert(
                title: Text("Error"),
                message: Text("Please select at least one person to split with, unless you're splitting with entities we can't see? 🤔"),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    // Split bill and add separate transaction to Friend data for everyone who has been selected by the user
    func splitBill(totalAmount: Double) {
        let shareAmount = totalAmount / Double(selectedFriends.count)
        for friendId in selectedFriends {
            if let index = friendsViewModel.friends.firstIndex(where: { $0.id == friendId }) {
                let newTransaction = Transaction(
                    id: UUID(),
                    friend: friendId,
                    amount: shareAmount,
                    type: selectedTransactionType,
                    date: Date(),
                    note: "(Split bill) " + note,
                    participants: selectedFriends
                )
                friendsViewModel.friends[index].transactions.append(newTransaction)
            }
        }
        friendsViewModel.saveFriends()
    }
}

// For selecting multiple people
struct MultipleSelectionRow: View {
    var friend: Friend
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: self.action) {
            HStack {
                Text(friend.name)
                if self.isSelected {
                    Spacer()
                    Image(systemName: "checkmark")
                }
            }
        }
    }
}
