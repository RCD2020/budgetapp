//
//  BudgetStore.swift
//  Budget
//
//  Created by Colby Davis on 10/21/22.
//

import Foundation
import SwiftUI

class BudgetStore: ObservableObject {
    @Published var budget: Budget = Budget(backups: [Budget().backup])
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
        .appendingPathComponent("budget.data")
    }
    
    static func load(completion: @escaping (Result<Budget, Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = try fileURL()
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        completion(.success(Budget(backups: [Budget().backup])))
                    }
                    return
                }
                let budgets = try JSONDecoder().decode(Budget.self, from: file.availableData)
                DispatchQueue.main.async {
                    completion(.success(budgets))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    static func save(budget: Budget, completion: @escaping (Result<Int, Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try JSONEncoder().encode(budget)
                let outfile = try fileURL()
                try data.write(to: outfile)
                DispatchQueue.main.async {
                    completion(.success(1))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
