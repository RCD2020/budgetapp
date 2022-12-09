//
//  NewTransactionView.swift
//  Budget
//
//  Created by Colby Davis on 10/20/22.
//

import SwiftUI

struct NewTransactionView: View {
    @Binding var data: History.Data
    @Binding var isIn: Bool
    
    var body: some View {
        Form {
            TextField("Name", text: $data.source)
            CurrencyTextField(numberFormatter: History.numberFormatter, value: $data.amount)
            Picker("In / Out", selection: $isIn) {
                Text("In").tag(true)
                Text("Out").tag(false)
            }
            DatePicker("Data", selection: $data.date, displayedComponents: [.date])
        }
    }
}

struct NewTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        NewTransactionView(data: .constant(History.Data()), isIn: .constant(true))
    }
}
