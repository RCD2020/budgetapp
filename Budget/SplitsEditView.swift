//
//  SplitsEditView.swift
//  Budget
//
//  Created by Colby Davis on 10/15/22.
//

import SwiftUI

struct SplitsEditView: View {
    @Binding var data: Budget.Data
    @State private var newSplit = ""
    
    var body: some View {
        VStack {
            Form {
                HStack {
                    Text("Spending")
                    TextField("", value: $data.settings.spendSplit, formatter: NumberFormatter())
                    Stepper(value: $data.settings.spendSplit, in: 0...100) {
                        EmptyView()
                    }
                }
                
                ForEach($data.settings.splits) { $split in
                    
                    HStack {
                        Text(split.name)
                        TextField("", value: $split.portion, formatter: NumberFormatter())
                        Stepper(value: $split.portion, in: 0...100) {
                            EmptyView()
                        }
                    }
                }
                .onDelete { indices in
                    data.settings.splits.remove(atOffsets: indices)
                }
                
                HStack {
                    TextField("New Split", text: $newSplit)
                    Button(action: {
                        withAnimation {
                            let split = Splittee(name: newSplit, portion: 0, transferAmount: 0, history: [])
                            data.settings.splits.append(split)
                            newSplit = ""
                        }
                    }) {
                        Image(systemName: "plus.circle.fill")
                    }
                    .disabled(newSplit.isEmpty)
                }
            }
            
            if !data.settings.is100() {
                Label("Splits must add to 100", systemImage: "exclamationmark.circle")
                    .foregroundColor(.red)
                    .bold()
            }
            
        }
    }
}

struct SplitsEditView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SplitsEditView(data: .constant(Budget.sampleData.data))
        }
    }
}
