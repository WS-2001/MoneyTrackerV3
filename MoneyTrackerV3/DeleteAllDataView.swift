//
//  DeleteAllDataView.swift
//  MoneyTrackerV3
//
//  Created by Wares on 20/04/2024.
//

import Foundation
import SwiftUI

struct DeleteAllDataView: View {
    @ObservedObject var friendsViewModel: FriendsViewModel

    var body: some View {
        Form {
            // Delete All Data
            Section(header: Text("DANGER AREA")) {
                Button(action: {
                    showDeleteAllDataConfirmation()
                }) {
                    Text("Delete All Data")
                        .foregroundColor(.red)
                }
                
                Text("This will remove all friends and transactions. \n\nThis action cannot be undone.")
            }
        }
        .navigationTitle("Delete All Data")
    }
    
    // Alert to CONFIRM data deletion
    private func showDeleteAllDataConfirmation() {
        let alert = UIAlertController(title: "Delete All Data", message: "Are you sure you want to delete all data? This will remove all friends and transactions. This action cannot be undone.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            deleteAllData()
        }))
        
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true)
    }

    // Actual function to call delete all data method
    private func deleteAllData() {
        friendsViewModel.deleteAllData()
    }
}
