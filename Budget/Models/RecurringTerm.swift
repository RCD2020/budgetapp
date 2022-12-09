//
//  RecurringTerm.swift
//  Budget
//
//  Created by Colby Davis on 10/19/22.
//

import Foundation

enum RecurringTerm: Codable {
    case weeklyRecur
    case monthlyRecur
    case quarterly
    case yearly
    
    var name: String {
        switch self {
        case .weeklyRecur: return "weekly"
        case .monthlyRecur: return "monthly"
        case .quarterly: return "quarterly"
        case .yearly: return "yearly"
        }
    }
    
    var amtInYear: Int {
        switch self {
        case .weeklyRecur: return 52
        case .monthlyRecur: return 12
        case .quarterly: return 4
        case .yearly: return 1
        }
    }
}
