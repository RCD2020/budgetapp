//
//  Formatting.swift
//  Budget
//
//  Created by Colby Davis on 10/14/22.
//

import Foundation

extension Int {
    var currencyFormat: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: Float(self) / 100 )) ?? ""
    }
}

extension Date {
    var transactionFormat: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: self)
    }
    
    var monthFormat: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLLL yyyy"
        return formatter.string(from: self)
    }
    
    var monthTimeFormat: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yy hh:mm:ss"
        return formatter.string(from: self)
    }
}
