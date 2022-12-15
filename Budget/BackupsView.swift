//
//  BackupsView.swift
//  Budget
//
//  Created by Colby Davis on 10/21/22.
//

import SwiftUI

struct BackupsView: View {
    @State var isPresDelete: Bool = false
    @Binding var budget: Budget
    
    var body: some View {
        VStack {
            List {
                // List Backups
                ForEach(budget.backups) { backup in
                    // View Backup
                    NavigationLink(destination: BackupView(budget: $budget, backup: backup)) {
                        Text(backup.backupDate.monthTimeFormat)
                            .font(.headline)
                    }
                }
                .onDelete { indices in
                    // Remove Backup
                    budget.backups.remove(atOffsets: indices)
                    // Save Action
                    BudgetStore.save(budget: budget) { result in
                        if case .failure(let error) = result {
                            fatalError(error.localizedDescription)
                        }
                    }
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
            
            Button("Delete All Data", role: .destructive) {
                isPresDelete = true
            }
            .confirmationDialog("Are you sure?",
                                isPresented: $isPresDelete) {
                Button("Delete all data? (excluding backups)", role: .destructive) {
                    isPresDelete = false
                    budget.clear()
                    BudgetStore.save(budget: budget) { result in
                        if case .failure(let error) = result {
                            fatalError(error.localizedDescription)
                        }
                    }
                }
            }
            .bold()
            
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
