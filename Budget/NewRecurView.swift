//
//  NewRecurView.swift
//  Budget
//
//  Created by Colby Davis on 10/19/22.
//

import SwiftUI

struct NewRecurView: View {
    @Binding var data: Recurring.Data
    @State private var test: Int = 54
    
    var body: some View {
        Form {
            TextField("Name", text: $data.name)
            CurrencyTextField(numberFormatter: data.numberFormatter, value: $data.cost)
            Picker("Frequency", selection: $data.term) {
                Text("Weekly").tag(RecurringTerm.weeklyRecur)
                Text("Monthly").tag(RecurringTerm.monthlyRecur)
                Text("Quarterly").tag(RecurringTerm.quarterly)
                Text("Yearly").tag(RecurringTerm.yearly)
            }
//            Text("\(data.cost)")
        }
    }
}

struct NewRecurView_Previews: PreviewProvider {
    static var previews: some View {
        NewRecurView(data: .constant(Recurring.Data()))
    }
}
