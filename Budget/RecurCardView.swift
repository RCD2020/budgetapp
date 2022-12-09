//
//  RecurCardView.swift
//  Budget
//
//  Created by Colby Davis on 10/19/22.
//

import SwiftUI

struct RecurCardView: View {
    let recur: Recurring
    let payTerm: PayTerm
    
    var body: some View {
        HStack {
            Text(recur.name)
                .font(.headline)
            Spacer()
            
            VStack(alignment: .trailing) {
                Text("\(recur.cost.currencyFormat) \(recur.term.name)")
                Text("\(recur.termCost.currencyFormat) \(payTerm.name)")
            }
        }
//        .padding(2)
    }
}

struct RecurCardView_Previews: PreviewProvider {
    static var previews: some View {
        RecurCardView(recur: Recurring(name: "Netflix", term: .monthlyRecur, cost: 1500, payTerm: .weekly), payTerm: .weekly)
    }
}
