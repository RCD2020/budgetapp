//
//  BudgetApp.swift
//  Budget
//
//  Created by Colby Davis on 10/14/22.
//

import SwiftUI

@main
struct BudgetApp: App {
    @StateObject private var store = BudgetStore()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                MainView(budget: $store.budget) {
                    BudgetStore.save(budget: store.budget) { result in
                        if case .failure(let error) = result {
                            fatalError(error.localizedDescription)
                        }
                    }
                }
            }
            .onAppear {
                
                // Load Save Data
                BudgetStore.load { result in
                    switch result {
                    case .failure(let error):
                        fatalError(error.localizedDescription)
                    case .success(let budget):
                        store.budget = budget
                    }
                }
                
                // Backup
//                store.budget.newBackup()
                
                // Factor in New Subs
                store.budget.subtractRecurring()
            }
        }
    }
}
