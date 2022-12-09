//
//  PayStubView.swift
//  Budget
//
//  Created by Colby Davis on 10/14/22.
//

import SwiftUI

struct PayStubView: View {
    let stub: History
    
    var body: some View {
        HStack {
            VStack {
            Text(stub.date, style: .date)
                    .font(.headline)
//                Text("\(Date(timeIntervalSince1970: TimeInterval(stub.term * 604800 - 259200)))")
//                Text("\(stub.term)")
//                Text("\(stub.term * 604800 - 259200)")
//                Text("\(TimeInterval(stub.term * 604800 - 259200))")
//                Text("\(Date(timeIntervalSince1970: TimeInterval(stub.term * 604800 - 259200)))")
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text(stub.amount.currencyFormat)
                Text(stub.source)
            }
        }
        .padding(4)
    }
}

struct PayStubView_Previews: PreviewProvider {
    static var previews: some View {
        PayStubView(stub: History(source: "SpaceEks", amount: 250, date: Date(), term: Settings.termCalc(date: Date(), payTerm: .weekly), isTerm: false, histories: []))
    }
}
