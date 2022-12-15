//
//  SplitsTransferView.swift
//  Budget
//
//  Created by Colby Davis on 10/20/22.
//

import SwiftUI

struct SplitsTransferView: View {
    @Binding var budget: Budget
    @Binding var split: Splittee
    @State private var isNewTransactionView = false
    @State private var data = History.Data()
    @State private var isIn = false
    
    var body: some View {
        List {
            // Display Info
            Section(header: Text("Info")) {
                // Amount in Savings
                HStack {
                    Text("Amount")
                    Spacer()
                    Text(split.transferAmount.currencyFormat)
                }
                
                // Portion Percentage
                HStack {
                    Text("Portion")
                    Spacer()
                    Text("\(split.portion)%")
                }
            }
            
            // List of Transactions
            Section(header: Text("Transactions"), footer: Text("The number shown on the categories is net \(split.name) versus earning, for example if it is -$100 then you spent $100 more than you earned for \(split.name).")) {
                ForEach(split.history) { history in
                    HStack {
                        if history.isTerm {
                            // Display Collection of Transactions
                            NavigationLink(destination: PurchaseListView(stubs: history.histories)
                                .navigationTitle(Text(history.date.monthFormat))) {
                                PurchaseMonthCardView(stub: history)
                            }
                        } else {
                            // Display Transaction
                            PurchaseCardView(stub: history)
                        }
                    }
                }
            }
        }
        .navigationTitle(split.name)
        .toolbar {
            // Add Transaction Button
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    data = History.Data()
                    isNewTransactionView = true
                    isIn = false
                }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $isNewTransactionView) {
            // New Transaction Sheet
            NavigationStack {
                NewTransactionView(data: $data, isIn: $isIn, inName: "Refund", outName: "Transaction")
                    .navigationTitle(Text("Add Transaction"))
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            // Save New Transaction
                            Button("Done") {
                                isNewTransactionView = false
                                split.addTransaction(data: data, isIn: isIn)
                                // Save Action
                                BudgetStore.save(budget: budget) { result in
                                    if case .failure(let error) = result {
                                        fatalError(error.localizedDescription)
                                    }
                                }
                            }
                            .disabled(data.isEmpty())
                        }
                        
                        ToolbarItem(placement: .cancellationAction) {
                            // Cancel New Transaction
                            Button("Cancel") {
                                isNewTransactionView = false
                            }
                        }
                    }
            }
        }
    }
}

struct SplitsTransferView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SplitsTransferView(budget: .constant(Budget.sampleData), split: .constant(Budget.sampleData.settings.splits[0]))
        }
    }
}
