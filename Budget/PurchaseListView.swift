//
//  PurchaseListView.swift
//  Budget
//
//  Created by Colby Davis on 10/20/22.
//

import SwiftUI

struct PurchaseListView: View {
    let stubs: [History]
    
    var body: some View {
        List {
            ForEach(stubs) { stub in
                PurchaseCardView(stub: stub)
            }
        }
    }
}

struct PurchaseListView_Previews: PreviewProvider {
    static var previews: some View {
        PurchaseListView(stubs: [Budget.sampleData.purchases[0]])
    }
}
