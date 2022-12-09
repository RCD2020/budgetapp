//
//  PayTerm.swift
//  Budget
//
//  Created by Colby Davis on 10/19/22.
//

import Foundation

enum PayTerm: Codable {
    case weekly
    case biweekly
    case monthly
    
    var name: String {
        switch self {
        case .weekly: return "weekly"
        case .biweekly: return "biweekly"
        case .monthly: return "monthly"
        }
    }
    var singleName: String {
        switch self {
        case .weekly: return "week"
        case .biweekly: return "biweek"
        case .monthly: return "month"
        }
    }
    var seconds: Int {
        switch self {
        case .weekly: return 604800
        case .biweekly: return 1209600
        case .monthly: return 2628288
        }
    }
    var amtInMonth: Int {
        switch self {
        case .weekly: return 4
        case .biweekly: return 2
        case .monthly: return 1
        }
    }
    var amtInYear: Int {
        switch self {
        case .weekly: return 52
        case .biweekly: return 26
        case .monthly: return 12
        }
    }
    var offSet: Int {
        switch self {
        case .weekly: return 259200
        case .biweekly: return 259200
        case .monthly: return 0
        }
    }
    var weirdOffSet: Int {
        switch self {
        case .weekly: return 86400
        case .biweekly: return 86400
        case .monthly: return 43200
        }
    }
}
