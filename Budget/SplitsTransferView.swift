//
//  SplitsTransferView.swift
//  Budget
//
//  Created by Colby Davis on 10/20/22.
//

import SwiftUI

struct SplitsTransferView: View {
    @Binding var split: Splittee
    @State private var isNewTransactionView = false
    @State private var data = History.Data()
    @State private var isIn = false
    
    var body: some View {
        List {
            Section(header: Text("Info")) {
                HStack {
                    Text("Amount")
                    Spacer()
                    Text(split.transferAmount.currencyFormat)
                }
                
                HStack {
                    Text("Portion")
                    Spacer()
                    Text("\(split.portion)%")
                }
            }
            
            Section(header: Text("Transactions")) {
                ForEach(split.history) { history in
                    HStack {
                        if history.isTerm {
                            NavigationLink(destination: PurchaseListView(stubs: history.histories)
                                .navigationTitle(Text(history.date.monthFormat))) {
                                PurchaseMonthCardView(stub: history)
                            }
                        } else {
                            PurchaseCardView(stub: history)
                        }
                    }
                }
            }
        }
        .navigationTitle(split.name)
        .toolbar {
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
            NavigationStack {
                NewTransactionView(data: $data, isIn: $isIn)
                    .navigationTitle(Text("Add Transaction"))
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Done") {
                                isNewTransactionView = false
                                split.addTransaction(data: data, isIn: isIn)
                            }
                            .disabled(data.isEmpty())
                        }
                        
                        ToolbarItem(placement: .cancellationAction) {
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
            SplitsTransferView(split: .constant(Budget.sampleData.settings.splits[0]))
        }
    }
}
