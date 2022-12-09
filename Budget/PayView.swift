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
            Section(header: Text("Averages (Per \(budget.settings.payTerm.singleName))")) {
                
                HStack {
                    Label("Past Month", systemImage: "gobackward.30")
                    Spacer()
                    Text(budget.getMonthAverage().currencyFormat)
                }
                
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
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    isSplitsEditView = true
                    data = budget.data
                }) {
                    Image(systemName: "gearshape")
                }
            }
            
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
                SplitsEditView(data: $data)
                    .navigationTitle(Text("Edit Splits"))
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Done") {
                                isSplitsEditView = false
                                budget.update(from: data)
                            }
                                .disabled(!data.settings.is100())
                        }
                        
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                isSplitsEditView = false
                            }
                        }
                    }
            }
        }
        .sheet(isPresented: $isNewPayView) {
            NavigationStack {
                NewPayView(data: $newHistory)
                    .navigationTitle(Text("New Paycheck"))
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Done") {
                                isNewPayView = false
                                payTotal = budget.addPay(data: newHistory)
                            }
                            .disabled(newHistory.isEmpty())
                        }
                        
                        ToolbarItem(placement: .cancellationAction) {
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
