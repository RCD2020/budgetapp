//
//  PayTermCardView.swift
//  Budget
//
//  Created by Colby Davis on 10/17/22.
//

import SwiftUI

struct PayTermCardView: View {
    let stub: History
    
    var body: some View {
        HStack {
            VStack {
                Text(stub.date, style: .date)
                    .font(.headline)
//                Text("\(stub.term)")
            }
            Spacer()
            Text(stub.amount.currencyFormat)
        }
        .padding(4)
    }
}

struct PayTermCardView_Previews: PreviewProvider {
    static var previews: some View {
        PayTermCardView(stub: History(source: "SpaceEks", amount: 250, date: Date(), term: Settings.termCalc(date: Date(), payTerm: .weekly), isTerm: false, histories: []))
    }
}
