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
            
            Section(header: Text("Splits")) {
                ForEach(backup.settings.splits) { split in
                    HStack {
                        Text(split.name + ": \(split.portion)%")
                        Spacer()
                        Text(split.transferAmount.currencyFormat)
                    }
                }
            }
            
            Section {
                Button(action: {
                    budget.loadBackup(loadedBackup: backup)
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
