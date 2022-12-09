//
//  PayView.swift
//  Budget
//
//  Created by Colby Davis on 10/14/22.
//

import SwiftUI

struct PayView: View {
    @Binding var budget: Budget
    @State private var isSplitsEditView = false
    @State private var data = Budget.Data()
    @State private var isNewPayView = false
    @State private var newHistory = History.Data()
    @State private var payTotal = 0
    
    var body: some View {
        List {
            // Average Title
            Section(header: Text("Averages (Per \(budget.settings.payTerm.singleName))")) {
                
                // Average Past Month Label
                HStack {
                    Label("Past Month", systemImage: "gobackward.30")
                    Spacer()
                    Text(budget.getMonthAverage().currencyFormat)
                }
                
                // Average Past Year Label
                HStack {
                    Label("Past Year", systemImage: "gobackward.minus")
                    Spacer()
                    Text(budget.getYearAverage().currencyFormat)
                }
                
//                HStack {
//                    Label("All Time", systemImage: "infinity")
//                    Spacer()
//                    Text(budget.getTotalAverage().currencyFormat)
//                }
                
            }
            
            // Paycheck List
            Section(header: Text("History")) {
                
                ForEach(budget.payHistory.reversed()) { history in
                    HStack {
                        if history.isTerm {
                            NavigationLink(destination: PayTermView(stub: history)) {
                                PayTermCardView(stub: history)
                            }
                        } else {
                            PayStubView(stub: history)
                        }
                    }
                }
                
            }
        }
        .toolbar {
            // Show Splits Edit Sheet (how the paychecks are divided)
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    isSplitsEditView = true
                    data = budget.data
                }) {
                    Image(systemName: "gearshape")
                }
            }
            
            // Show New Paycheck Sheet
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    isNewPayView = true
                    newHistory = History.Data()
                }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $isSplitsEditView) {
            NavigationStack {
                // Edit Splits
                SplitsEditView(data: $data)
                    .navigationTitle(Text("Edit Splits"))
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            // Save New Split Configuration
                            Button("Done") {
                                // Update Splits
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
                            // Cancel Splits Edit
                            Button("Cancel") {
                                isSplitsEditView = false
                            }
                        }
                    }
            }
        }
        .sheet(isPresented: $isNewPayView) {
            NavigationStack {
                // New Paycheck Sheet
                NewPayView(data: $newHistory)
                    .navigationTitle(Text("New Paycheck"))
                    .toolbar {
                        // Save New Paycheck
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Done") {
                                isNewPayView = false
                                payTotal = budget.addPay(data: newHistory)
                                // Save Action
                                BudgetStore.save(budget: budget) { result in
                                    if case .failure(let error) = result {
                                        fatalError(error.localizedDescription)
                                    }
                                }
                            }
                            .disabled(newHistory.isEmpty())
                        }
                        
                        ToolbarItem(placement: .cancellationAction) {
                            // Cancel New Paycheck
                            Button("Cancel") {
                                isNewPayView = false
                            }
                        }
                    }
            }
        }
        .navigationTitle(Text("Paychecks"))
    }
}

struct PayView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            PayView(budget: .constant(Budget.sampleData))
        }
    }
}
