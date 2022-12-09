//
//  PurchaseMonthCardView.swift
//  Budget
//
//  Created by Colby Davis on 10/20/22.
//

import SwiftUI

struct PurchaseMonthCardView: View {
    let stub: History
    
    var body: some View {
        HStack {
            Text(stub.date.monthFormat)
                .font(.headline)
            Spacer()
            
            Text(stub.amount.currencyFormat)
        }
        .padding(4)
    }
}

struct PurchaseMonthCardView_Previews: PreviewProvider {
    static var previews: some View {
        PurchaseMonthCardView(stub: Budget.sampleData.purchases[0])
    }
}
