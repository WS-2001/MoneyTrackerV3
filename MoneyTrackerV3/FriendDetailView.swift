//
//  FriendDetailView.swift
//  MoneyTrackerV3
//
//  Created by Wares on 21/02/2024.
//
import SwiftUI
import Charts

struct FriendDetailView: View {
    @Binding var friend: Friend
    @ObservedObject var friendsViewModel: FriendsViewModel
    
    // Tracking allllll of these variables
    @State private var newTransactionAmount = ""
    @State private var selectedTransactionType = TransactionType.lend
    @State private var filterOption: FilterOption = .both
    @State private var isSortingOptionsVisible = false
    @State private var transactionNote = ""
    @State private var isEditingNote = false
    @State private var selectedTransactionID: UUID?
    @State private var isEditingTransaction = false
    @State private var showingEmptyTransactionAlert = false
    
    // Accessing the Settings and defaults if not set
    @AppStorage("notePreviewLines") private var notePreviewLines = 3
    @AppStorage("noteEditingSymbol") private var noteEditingSymbol = "pencil.circle"
    @AppStorage("showCharts") private var showCharts = true
    @AppStorage("enableNoteEditingIcon") private var enableNoteEditingIcon = true
    
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
            
            // Display chart only if toggle is enabled in Settings
            if showCharts {
                Section() { // Removed header text to minimise clutter
                    FriendBalanceChartView(friend: friend)
                }
            }
            
            // The list of friend's transactions
            List {
                ForEach(filteredTransactions()) { transaction in
                    let transactionType = transaction.type == .lend ? "Lent" : "Borrowed"
                    let formattedAmount = String(format: "%.2f", transaction.amount)
                    let formattedTransactionDate = formattedDate(transaction.date)
                    
                    VStack(alignment: .leading) {
                        Text("\(transactionType) £\(formattedAmount) on \(formattedTransactionDate)")
                        HStack {
                            // If note is NOT empty, display preview of note with notePreviewLines amount from Settings
                            if let note = transaction.note, !note.isEmpty {
                                Text("\(note)")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .lineLimit(notePreviewLines)
                            }

                            Spacer()

                            // Edit Transaction
                            Button(action: {
                                if let index = friend.transactions.firstIndex(where: { $0.id == transaction.id }) {
                                    selectedTransactionID = transaction.id
                                    isEditingTransaction = true
                                }
                            }) {
                                if enableNoteEditingIcon {
                                    Image(systemName: noteEditingSymbol)
                                        .foregroundColor(.blue)
                                }
                            }
                            .fullScreenCover(isPresented: $isEditingTransaction) {
                                if let index = friend.transactions.firstIndex(where: { $0.id == selectedTransactionID }) {
                                    EditTransactionView(transaction: $friend.transactions[index], friendsViewModel: friendsViewModel)
                                }
                            }
                        }
                    }
                }
                // Deleting transaction (with slide gesture)
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
                
                // Button itself (icon)
                Button {
                    // If empty, display alert
                    if newTransactionAmount.isEmpty {
                        showingEmptyTransactionAlert = true
                        return
                    }
                    
                    // Otherwise, continue
                    if let amount = Double(newTransactionAmount) {
                        let newTransaction = Transaction(id: UUID(), friend: friend.id, amount: amount, type: selectedTransactionType, date: Date(),note: transactionNote)
                        friend.transactions.append(newTransaction)
                        friendsViewModel.saveFriends()
                        newTransactionAmount = ""
                        transactionNote = ""
                    }
                } label: {
                    Image(systemName: "plus")
                        .font(.title3)
                }
                .foregroundColor(.white)
                .padding(10)
                .background(Color.blue)
                .cornerRadius(8)
                
            }
            .padding()
            .textFieldStyle(RoundedBorderTextFieldStyle())
        }
        .navigationTitle(friend.name)
        .alert(isPresented: $showingEmptyTransactionAlert) {
            Alert(title: Text("Empty Transaction"), message: Text("That's a very suspicious transaction! Please enter an amount before adding a transaction."), dismissButton: .default(Text("OK")))
        }
        
        // Sort options in the icon on the toolbar
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
    }
    
    private func sortedTransactions() -> [Transaction] {
        return friend.transactions.sorted(by: { $0.date > $1.date })
    }
    
    // Filtering transactions
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
    
    // Sorting transactions
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
    
    // Format date to display correctly
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    // Making the Sort options its own little pulldown menu and giving them a little icon next to them. Declutters the screen this way.
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

// For current friend's totalLend and totalBorrow values to be displayed in the bar chart
struct FriendBalanceChartView: View {
    let friend: Friend
    
    var body: some View {
        Chart {
            BarMark(
                x: .value("Amount", friend.totalLend),
                y: .value("Type", "Lent")
            )
            .foregroundStyle(.green)
            
            BarMark(
                x: .value("Amount", friend.totalBorrow),
                y: .value("Type", "Borrowed")
            )
            .foregroundStyle(.red)
        }
        .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
        .frame(height: 120)
    }
}
