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
            ForEach($budget.settings.splits) { $split in
                NavigationLink(destination: SplitsTransferView(split: $split)) {
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
    }
}

struct SplitsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SplitsView(budget: .constant(Budget.sampleData))
        }
    }
}
