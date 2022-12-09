//
//  RecurringView.swift
//  Budget
//
//  Created by Colby Davis on 10/19/22.
//

import SwiftUI

struct RecurringView: View {
    @Binding var budget: Budget
    @State private var isNewRecurView = false
    @State private var data = Recurring.Data()
    
    
    var body: some View {
        List {
            // Term Obligation Display
            Section(header: Text("Info")) {
                HStack {
                    Label("\(budget.settings.payTerm.name.capitalized) Obligation", systemImage: "creditcard")
                    Spacer()
                    Text(budget.obligation.currencyFormat)
                }
            }
            
            // Sort Buttons ( WIP: Causes Error )
            Section(header: Text("Sort by")) {
                HStack {
                    Button(action: {budget.recurSortByName()}) {
                        Text("Name")
                    }
                    .buttonStyle(.bordered)
                    
                    Spacer()
                    
                    Button(action: {budget.recurSortByCost()}) {
                        Text("Cost")
                    }
                    .buttonStyle(.bordered)
                    
                    Spacer()
                    
                    Button(action: {budget.recurSortByTermCost()}) {
                        Text("Cost per \(budget.settings.payTerm.singleName.capitalized)")
                    }
                    .buttonStyle(.bordered)
                }
//                Button(action: {budget.recurSortByName()}) {
//                    Text("Name")
//                }
//                Button(action: {budget.recurSortByCost()}) {
//                    Text("Cost")
//                }
//                Button(action: {budget.recurSortByTermCost()}) {
//                    Text("Cost per \(budget.settings.payTerm.singleName.capitalized)")
//                }
            }
            
            // List of Obligations
            Section(header: Text("Obligations")) {
                ForEach(budget.recurring) { recur in
                    RecurCardView(recur: recur, payTerm: budget.settings.payTerm)
                }
                .onDelete { indices in
                    // Remove Obligation
                    budget.recurring.remove(atOffsets: indices)
                    budget.tallyRecur()
                    // Save Action
                    BudgetStore.save(budget: budget) { result in
                        if case .failure(let error) = result {
                            fatalError(error.localizedDescription)
                        }
                    }
                }
            }
        }
        .toolbar {
            // New Obligation Button
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    isNewRecurView = true
                    data = Recurring.Data()
                }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $isNewRecurView) {
            // New Obligation Sheet
            NavigationStack {
                NewRecurView(data: $data)
                    .navigationTitle("New Recurring Cost")
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Done") {
                                // Add Obligation
                                budget.addRecurring(recur: Recurring(data: data, payTerm: budget.settings.payTerm))
                                isNewRecurView = false
                                // Save Action
                                BudgetStore.save(budget: budget) { result in
                                    if case .failure(let error) = result {
                                        fatalError(error.localizedDescription)
                                    }
                                }
                            }
                        }
                        ToolbarItem(placement: .cancellationAction) {
                            // Cancel New Obligation
                            Button("Cancel") {
                                isNewRecurView = false
                            }
                        }
                    }
            }
        }
    }
}

struct RecurringView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            RecurringView(budget: .constant(Budget.sampleData))
        }
    }
}
