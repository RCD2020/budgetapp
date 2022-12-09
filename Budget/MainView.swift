//
//  MainView.swift
//  Budget
//
//  Created by Colby Davis on 10/14/22.
//

import SwiftUI

struct MainView: View {
    @Binding var budget: Budget
    @Environment(\.scenePhase) private var scenePhase
    @State private var isMainSettingsView = false
    @State private var data = Budget.Data()
    let saveAction: ()->Void
    
    var body: some View {
        List {
            Section(header: Text("Transactions")) {
                
                // Spending Label
                HStack {
                    Label("Spending", systemImage: "dollarsign.circle")
                    Spacer()
                    Text(budget.spending.currencyFormat)
                }
                
//                NavigationLink(destination: ContentView()) {
//                    Label("Kill Me", systemImage: "x.circle")
//                }
                
                NavigationLink(destination: PurchaseView(budget: $budget)) {
                    Label("Purchases", systemImage: "cart.badge.plus")
                }
                
//                NavigationLink(destination: PayView(budget: $budget)) {
//                    Label("Paychecks", systemImage: "banknote")
//                }
                
            }
            
//            Section(header: Text("Recurring Payments")) {
//                NavigationLink(destination: RecurringView(budget: $budget)) {
//                    HStack {
//                        Label("\(budget.settings.payTerm.name.capitalized) Obligation", systemImage: "creditcard")
//                        Spacer()
//                        Text(budget.obligation.currencyFormat)
//                    }
//                }
//            }
//
//            Section(header: Text("Splits")) {
//                NavigationLink(destination: SplitsView(budget: $budget)) {
//                    Label("Splits", systemImage: "bag")
//                }
//            }
//
//            Section(header: Text("Backups")) {
//                NavigationLink(destination: BackupsView(budget: $budget)) {
//                    Label("Backups", systemImage: "square.and.arrow.down")
//                }
//            }
//        }
//        .toolbar {
//            ToolbarItem(placement: .primaryAction) {
//                Button(action: {
//                    isMainSettingsView = true
//                    data = budget.data
//                }) {
//                    Image(systemName: "gearshape")
//                }
//            }
//        }
//        .sheet(isPresented: $isMainSettingsView) {
//            NavigationStack {
//                MainSettingsView(data: $data)
//                    .navigationTitle(Text("Settings"))
//                    .toolbar {
//                        ToolbarItem(placement: .confirmationAction) {
//                            Button("Done") {
//                                isMainSettingsView = false
//
//                                if budget.settings.payTerm != data.settings.payTerm {
//
//                                    budget.update(from: data)
//                                    budget.refactorPayTerm()
//                                } else {
//                                    budget.update(from: data)
//                                }
//                            }
//                        }
//
//                        ToolbarItem(placement: .cancellationAction) {
//                            Button("Cancel") {
//                                isMainSettingsView = false
//                            }
//                        }
//                    }
//            }
        }
        .onAppear {
            budget.subtractRecurring()
        }
        .onChange(of: scenePhase) { phase in
            if phase == .inactive { saveAction() }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MainView(budget: .constant(Budget.sampleData), saveAction: {})
        }
    }
}
