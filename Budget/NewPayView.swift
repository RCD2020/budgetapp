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
        Form {
            TextField("Name", text: $data.source)
            CurrencyTextField(numberFormatter: History.numberFormatter, value: $data.amount)
            DatePicker("Date", selection: $data.date, displayedComponents: [.date])
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
