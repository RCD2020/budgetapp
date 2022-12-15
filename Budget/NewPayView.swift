//
//  NewPayView.swift
//  Budget
//
//  Created by Colby Davis on 10/15/22.
//

import SwiftUI

struct NewPayView: View {
    @Binding var data: History.Data
    
    var body: some View {
        VStack {
            Form {
                TextField("Name", text: $data.source)
                CurrencyTextField(numberFormatter: History.numberFormatter, value: $data.amount)
                DatePicker("Date", selection: $data.date, displayedComponents: [.date])
            }
            
            if data.isEmpty() {
                Label("Requires Name and Price", systemImage: "exclamationmark.circle")
                    .foregroundColor(.red)
                    .bold()
            }
        }
    }
}

struct NewPayView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            NewPayView(data: .constant(History.Data()))
        }
    }
}
