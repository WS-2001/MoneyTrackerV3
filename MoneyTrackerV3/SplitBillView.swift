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
    
    @State private var totalAmountString: String = ""
    @State private var selectedFriends: [UUID] = []
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Total Amount")) {
                        TextField("Total Amount", text: $totalAmountString)
                            .keyboardType(.decimalPad)
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
                    
                    Button("Split Bill") {
                        if let totalAmount = Double(totalAmountString) {
                            splitBill(totalAmount: totalAmount)
                            isPresented = false // Dismiss sheet after splitting bill
                        }
                    }
                }
                .navigationBarTitle("Split Bill", displayMode: .inline)
            }
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
                    type: .borrow,
                    date: Date(),
                    note: "Split bill",
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
