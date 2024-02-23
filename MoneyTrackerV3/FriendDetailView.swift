//
//  FriendDetailView.swift
//  MoneyTrackerV3
//
//  Created by Wares on 21/02/2024.
//
import SwiftUI

struct FriendDetailView: View {
    @Binding var friend: Friend
    @ObservedObject var friendsViewModel: FriendsViewModel
    @State private var newTransactionAmount = ""
    @State private var selectedTransactionType = TransactionType.lend
    @State private var filterOption: FilterOption = .both
    @State private var isSortingOptionsVisible = false
    
    var body: some View {
        VStack {
            // Filtering Options
            Picker("Show", selection: $filterOption) {
                Text("Both").tag(FilterOption.both)
                Text("Lent").tag(FilterOption.lent)
                Text("Borrowed").tag(FilterOption.borrowed)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
                        
            List {
                ForEach(filteredTransactions()) { transaction in
                    let transactionType = transaction.type == .lend ? "Lent" : "Borrowed"
                    let formattedAmount = String(format: "%.2f", transaction.amount)
                    let formattedTransactionDate = formattedDate(transaction.date)
                    
                    Text("\(transactionType) £\(formattedAmount) on \(formattedTransactionDate)")
                }
                .onDelete { indexSet in
                    friend.transactions.remove(atOffsets: indexSet)
                    friendsViewModel.saveFriends()
                }
            }
            
            // Adding a new Transaction
            HStack {
                Text("£")
                    .font(.title)
                    .foregroundColor(.blue)
                
                TextField("Enter amount", text: $newTransactionAmount)
                    .keyboardType(.decimalPad)
                    .padding(.trailing, 5)
                
                Picker("Type", selection: $selectedTransactionType) {
                    Text("Lend").tag(TransactionType.lend)
                    Text("Borrow").tag(TransactionType.borrow)
                }
                .pickerStyle(SegmentedPickerStyle())
                
                Button("Add Transaction") {
                    if let amount = Double(newTransactionAmount) {
                        let newTransaction = Transaction(id: UUID(), friend: friend.id, amount: amount, type: selectedTransactionType, date: Date())
                        friend.transactions.append(newTransaction)
                        friendsViewModel.saveFriends()
                        newTransactionAmount = ""
                    }
                }
            }
            .padding()
            .textFieldStyle(RoundedBorderTextFieldStyle())
        }
        .navigationTitle(friend.name)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Menu {
                    Button(action: {
                        sortTransactions(.amountDescending)
                    }) {
                        Label("Amount (High to Low)", systemImage: "dollarsign.circle")
                    }
                    Button(action: {
                        sortTransactions(.amountAscending)
                    }) {
                        Label("Amount (Low to High)", systemImage: "dollarsign.circle.fill")
                    }
                    Divider()
                    Button(action: {
                        sortTransactions(.dateDescending)
                    }) {
                        Label("Date (Latest)", systemImage: "calendar.circle")
                    }
                    Button(action: {
                        sortTransactions(.dateAscending)
                    }) {
                        Label("Date (Oldest)", systemImage: "calendar.circle.fill")
                    }
                } label: {
                    Label("Sort", systemImage: "arrow.up.arrow.down.circle")
                }
                .menuStyle(BorderlessButtonMenuStyle())
            }
        }
    
//        .popover(isPresented: $isSortingOptionsVisible, arrowEdge: .top) {
//            sortingOptionsView()
//        }
    }
    
    private func sortedTransactions() -> [Transaction] {
        return friend.transactions.sorted(by: { $0.date > $1.date })
    }
    
    private func filteredTransactions() -> [Transaction] {
        switch filterOption {
        case .lent:
            return friend.transactions.filter { $0.type == .lend }
        case .borrowed:
            return friend.transactions.filter { $0.type == .borrow }
        case .both:
            return friend.transactions
        }
    }
    
    private func sortTransactions(_ option: SortOption) {
        switch option {
        case .dateDescending:
            friend.transactions.sort(by: { $0.date > $1.date })
        case .dateAscending:
            friend.transactions.sort(by: { $0.date < $1.date })
        case .amountDescending:
            friend.transactions.sort(by: { $0.amount > $1.amount })
        case .amountAscending:
            friend.transactions.sort(by: { $0.amount < $1.amount })
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func sortingOptionsView() -> some View {
        Menu("Sort") {
            Button(action: {
                sortTransactions(.amountDescending)
            }) {
                Label("Amount (High to Low)", systemImage: "dollarsign.circle")
            }
            Button(action: {
                sortTransactions(.amountAscending)
            }) {
                Label("Amount (Low to High)", systemImage: "dollarsign.circle.fill")
            }
            Divider()
            Button(action: {
                sortTransactions(.dateDescending)
            }) {
                Label("Date (Latest)", systemImage: "calendar.circle")
            }
            Button(action: {
                sortTransactions(.dateAscending)
            }) {
                Label("Date (Oldest)", systemImage: "calendar.circle.fill")
            }
        }
        .padding()
        .menuStyle(BorderlessButtonMenuStyle()) // Add this line to make it a pull-down menu
    }

}

enum SortOption: String, CaseIterable {
    case dateDescending = "Date (Latest)"
    case dateAscending = "Date (Oldest)"
    case amountDescending = "Amount (High to Low)"
    case amountAscending = "Amount (Low to High)"
}

enum FilterOption: String, CaseIterable {
    case both = "Both"
    case lent = "Lent"
    case borrowed = "Borrowed"
}
