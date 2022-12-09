//
//  BackupView.swift
//  Budget
//
//  Created by Colby Davis on 10/21/22.
//

import SwiftUI

struct BackupView: View {
    @Binding var budget: Budget
    var backup: Backup
    
    var body: some View {
        List {
            // Display Backup Info
            Section(header: Text("Info")) {
                HStack {
                    Text("Spending")
                    Spacer()
                    Text(backup.spending.currencyFormat)
                }
                HStack {
                    Text("Obligation")
                    Spacer()
                    Text(backup.obligation.currencyFormat)
                }
                HStack {
                    Text("Backup Date")
                    Spacer()
                    Text(backup.backupDate.monthTimeFormat)
                }
            }
            
            // Display Splits
            Section(header: Text("Splits")) {
                ForEach(backup.settings.splits) { split in
                    HStack {
                        Text(split.name + ": \(split.portion)%")
                        Spacer()
                        Text(split.transferAmount.currencyFormat)
                    }
                }
            }
            
            // Restore Back !!! WIP: ( Causes Error ) !!!
            Section {
                Button(action: {
                    // Loads Backup
                    budget.loadBackup(loadedBackup: backup)
                    // Save Action
                    BudgetStore.save(budget: budget) { result in
                        if case .failure(let error) = result {
                            fatalError(error.localizedDescription)
                        }
                    }
                }) {
                    Label("Restore Backup", systemImage: "square.and.arrow.down")
                        .font(.headline)
                }
            }
        }
    }
}

struct BackupView_Previews: PreviewProvider {
    static var previews: some View {
        BackupView(budget: .constant(Budget.sampleData), backup: Budget.sampleData.backups[0])
    }
}
