//
//  SplitsView.swift
//  Budget
//
//  Created by Colby Davis on 10/20/22.
//

import SwiftUI

struct SplitsView: View {
    @Binding var budget: Budget
    @State private var isSplitsEditView = false
    @State private var data = Budget.Data()
    
    var body: some View {
        List {
            // Displays all splits
            ForEach($budget.settings.splits) { $split in
                // Split View Screen
                NavigationLink(destination: SplitsTransferView(budget: $budget, split: $split)) {
                    HStack {
                        Text(split.name)
                            .font(.headline)
                        Spacer()
                        Text(split.transferAmount.currencyFormat)
                    }
                }
            }
        }
        .navigationTitle(Text("Splits"))
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                // Display Splits Edit Button
                Button(action: {
                    isSplitsEditView = true
                    data = budget.data
                }) {
                    Image(systemName: "gearshape")
                }
            }
        }
        .sheet(isPresented: $isSplitsEditView) {
            NavigationStack {
                // Splits Edit Sheet
                SplitsEditView(data: $data)
                    .navigationTitle(Text("Edit Splits"))
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            // Save Splits Configuration Button
                            Button("Done") {
                                isSplitsEditView = false
                                budget.update(from: data)
                                // Save Action
                                BudgetStore.save(budget: budget) { result in
                                    if case .failure(let error) = result {
                                        fatalError(error.localizedDescription)
                                    }
                                }
                            }
                                .disabled(!data.settings.is100())
                        }
                        
                        ToolbarItem(placement: .cancellationAction) {
                            // Cancel Splits Configuration Button
                            Button("Cancel") {
                                isSplitsEditView = false
                            }
                        }
                    }
            }
        }
    }
}

struct SplitsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SplitsView(budget: .constant(Budget.sampleData))
        }
    }
}
