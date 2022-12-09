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
            Section(header: Text("Info")) {
                HStack {
                    Label("\(budget.settings.payTerm.name.capitalized) Obligation", systemImage: "creditcard")
                    Spacer()
                    Text(budget.obligation.currencyFormat)
                }
            }
            
            Section(header: Text("Sort by")) {
                Button(action: {budget.recurSortByName()}) {
                    Text("Name")
                }
                Button(action: {budget.recurSortByCost()}) {
                    Text("Cost")
                }
                Button(action: {budget.recurSortByTermCost()}) {
                    Text("Cost per \(budget.settings.payTerm.singleName.capitalized)")
                }
            }
            
            Section(header: Text("Obligations")) {
                ForEach(budget.recurring) { recur in
                    RecurCardView(recur: recur, payTerm: budget.settings.payTerm)
                }
                .onDelete { indices in
                    budget.recurring.remove(atOffsets: indices)
                    budget.tallyRecur()
                }
            }
        }
        .toolbar {
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
            NavigationStack {
                NewRecurView(data: $data)
                    .navigationTitle("New Recurring Cost")
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Done") {
                                budget.addRecurring(recur: Recurring(data: data, payTerm: budget.settings.payTerm))
                                isNewRecurView = false
                            }
                        }
                        ToolbarItem(placement: .cancellationAction) {
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
