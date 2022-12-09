//
//  PurchaseView.swift
//  Budget
//
//  Created by Colby Davis on 10/20/22.
//

import SwiftUI

struct PurchaseView: View {
    @Binding var budget: Budget
    @State private var isNewPurchaseView = false
//    @State private var data = History.Data()
//    @State private var data = History.fauxData(date: Date())
    @State private var isIn = false
    
    let date = Date()
    
    var body: some View {
        List {
            Section(header: Text("Info")) {
                HStack {
                    Label("Spending", systemImage: "dollarsign.circle")
                    Spacer()
                    Text(budget.spending.currencyFormat)
                }
            }
            
            Section(header: Text("Purchases")) {
                ForEach(budget.purchases) { history in
                    HStack {
                        if history.isTerm {
                            NavigationLink(destination: PurchaseListView(stubs: history.histories)) {
                                PurchaseMonthCardView(stub: history)
                            }
                        } else {
                            PurchaseCardView(stub: history)
                        }
                    }
                }
            }
        }
//        .navigationTitle(Text("Purchases"))
//        .toolbar {
//            ToolbarItem(placement: .primaryAction) {
//                Button(action: {
//                    data = History.Data()
//                    isNewPurchaseView = true
//                    isIn = false
//                }) {
//                    Image(systemName: "plus")
//                }
//            }
//        }
//        .sheet(isPresented: $isNewPurchaseView) {
//            NavigationStack {
//                NewTransactionView(data: $data, isIn: $isIn)
//                    .navigationTitle(Text("New Purchase"))
//                    .toolbar {
//                        ToolbarItem(placement: .confirmationAction) {
//                            Button("Done") {
//                                budget.addPurchase(data: data, isIn: isIn)
//                                isNewPurchaseView = false
//                            }
//                            .disabled(data.isEmpty())
//                        }
//
//                        ToolbarItem(placement: .cancellationAction) {
//                            Button("Cancel") {
//                                isNewPurchaseView = false
//                            }
//                        }
//                    }
//            }
//        }
    }
}

struct PurchaseView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            PurchaseView(budget: .constant(Budget.sampleData))
        }
    }
}
