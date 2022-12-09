//
//  PayTermView.swift
//  Budget
//
//  Created by Colby Davis on 10/17/22.
//

import SwiftUI

struct PayTermView: View {
    let stub: History
    
    var body: some View {
        List {
            Section(header: Text(stub.source)) {
                ForEach(stub.histories) { history in
                    PayStubView(stub: history)
                }
            }
        }
    }
}

struct PayTermView_Previews: PreviewProvider {
    static var previews: some View {
        PayTermView(stub: History(source: "Week of Oct 6, 2022", amount: 500, date: Date(), term: Settings.termCalc(date: Date(), payTerm: .weekly), isTerm: true, histories: [
            History(source: "Tesl", amount: 250, date: Date(), term: Settings.termCalc(date: Date(), payTerm: .weekly), isTerm: false, histories: []),
            History(source: "SpaceEks", amount: 250, date: Date(), term: Settings.termCalc(date: Date(), payTerm: .weekly), isTerm: false, histories: [])
        ]))
    }
}
