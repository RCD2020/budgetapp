//
//  BackupsView.swift
//  Budget
//
//  Created by Colby Davis on 10/21/22.
//

import SwiftUI

struct BackupsView: View {
    @Binding var budget: Budget
    
    var body: some View {
        List {
            ForEach(budget.backups) { backup in
                NavigationLink(destination: BackupView(budget: $budget, backup: backup)) {
                    Text(backup.backupDate.monthTimeFormat)
                        .font(.headline)
                }
            }
            .onDelete { indices in
                budget.backups.remove(atOffsets: indices)
            }
        }
        .navigationTitle(Text("Backups"))
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    budget.newBackup()
                }) {
                    Image(systemName: "plus")
                }
            }
        }
    }
}

struct BackupsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            BackupsView(budget: .constant(Budget.sampleData))
        }
    }
}
