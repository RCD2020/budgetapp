//
//  PurchaseCardView.swift
//  Budget
//
//  Created by Colby Davis on 10/20/22.
//

import SwiftUI

struct PurchaseCardView: View {
    let stub: History
    
    var body: some View {
        HStack {
            Text(stub.date, style: .date)
                .font(.headline)
            Spacer()
            
            VStack(alignment: .trailing) {
                Text(stub.source)
                Text("\(stub.amount.currencyFormat)")
            }
        }
//        .padding(4)
    }
}

struct PurchaseCardView_Previews: PreviewProvider {
    static var previews: some View {
        PurchaseCardView(stub: Budget.sampleData.purchases[0])
    }
}
