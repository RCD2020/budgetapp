//
//  Budget.swift
//  Budget
//
//  Created by Colby Davis on 10/14/22.
//

import Foundation

struct Splittee: Identifiable, Codable {
    var id: UUID
    var name: String
    var portion: Int
    var transferAmount: Int
    var history: [History]
    
    init(name: String, portion: Int, transferAmount: Int, history: [History]) {
        self.id = UUID()
        self.name = name
        self.portion = portion
        self.transferAmount = transferAmount
        self.history = history
    }
    
    mutating func addTransaction(newHistory: History) {
        let category = Calendar.current.dateComponents([.month, .year], from: newHistory.date)
        var collide = false
        
        for (index, savedHistory) in history.enumerated() {
            if Calendar.current.dateComponents([.month, .year], from: savedHistory.date) == category {
                
                history[index].histories.append(newHistory)
                history[index].amount += newHistory.amount
                history[index].histories.sort {
                    $0.date > $1.date
                }
                collide = true
                break
            }
        }
        
        if !collide {
            history.append(History(source: "n/a", amount: newHistory.amount, date: newHistory.date, term: 0, isTerm: true, histories: [newHistory]))
        }
        history.sort {
            $0.date > $1.date
        }
        
        transferAmount += newHistory.amount
    }
    
    mutating func addTransaction(data: History.Data, isIn: Bool) {
        var mutable = data
        if !isIn {
            mutable.amount = -mutable.amount
        }
        let newHistory = History(data: mutable)
        
        addTransaction(newHistory: newHistory)
    }
}

struct Settings: Codable {
    var splits: [Splittee]
    var spendSplit: Int
    var payTerm: PayTerm
    
    init(splits: [Splittee] = [], spendSplit: Int = 100, payTerm: PayTerm = .weekly) {
        self.splits = splits
        self.spendSplit = spendSplit
        self.payTerm = payTerm
    }
    
    func is100()->Bool {
        var total = spendSplit
        
        for split in self.splits {
            total += split.portion
        }
        
        return total == 100
    }
    
    func totalSplits()->Int {
        var total = spendSplit
        
        for split in self.splits {
            total += split.portion
        }
        
        return total
    }
    
    static func getDate(term: Int, payTerm: PayTerm)->Date {
        return Date(timeIntervalSince1970: TimeInterval(term * payTerm.seconds - payTerm.offSet + payTerm.weirdOffSet))
    }
    
    static func termCalc(date: Date, payTerm: PayTerm)->Int {
            let seconds = Int(date.timeIntervalSince1970)
            let term = (seconds + payTerm.offSet) / payTerm.seconds
            return term
        }
}

struct History: Identifiable, Codable {
    let id: UUID
    var source: String
    var amount: Int
    var date: Date
    var term: Int
    var isTerm: Bool
    var histories: [History]
    
    init(source: String, amount: Int, date: Date, term: Int = 0, isTerm: Bool = false, histories: [History] = []) {
        self.id = UUID()
        self.source = source
        self.amount = amount
        self.date = date
        self.term = term
        self.isTerm = isTerm
        self.histories = histories
    }
    
    func isEmpty()->Bool {
        if source.isEmpty || amount == 0 {
            return true
        }
        return false
    }
    
    mutating func addhistory(history: History) {
        histories.append(history)
        amount += history.amount
    }
}

struct Recurring: Identifiable, Codable {
    let id: UUID
    var name: String
    var term: RecurringTerm
    var cost: Int
    var termCost: Int
    
    init(name: String, term: RecurringTerm, cost: Int, payTerm: PayTerm) {
        self.id = UUID()
        self.name = name
        self.term = term
        self.cost = cost
        self.termCost = (cost * term.amtInYear) / payTerm.amtInYear
    }
    
    mutating func refactorTermCost(payTerm: PayTerm) {
        termCost = (cost * term.amtInYear) / payTerm.amtInYear
    }
}

struct Backup: Identifiable, Codable {
    let id: UUID
    var spending: Int
    var settings: Settings
    var payHistory: [History]
    var obligation: Int
    var recurring: [Recurring]
    var purchases: [History]
    var lastLogonTerm: Int
    var backupDate: Date
    
    init(spending: Int, settings: Settings, payHistory: [History], obligation: Int, recurring: [Recurring], purchases: [History], lastLogonTerm: Int, backupDate: Date) {
        self.id = UUID()
        self.spending = spending
        self.settings = settings
        self.payHistory = payHistory
        self.obligation = obligation
        self.recurring = recurring
        self.purchases = purchases
        self.lastLogonTerm = lastLogonTerm
        self.backupDate = backupDate
    }
}

struct Budget: Codable {
    var spending: Int
    var settings: Settings
    var payHistory: [History]
    var obligation: Int
    var recurring: [Recurring]
    var purchases: [History]
    var lastLogonTerm: Int
    var backups: [Backup]
    
    init(spending: Int = 0, settings: Settings = Settings(), payHistory: [History] = [], obligation: Int = 0, recurring: [Recurring] = [], purchases: [History] = [], lastLogonTerm: Int = 0, backups: [Backup] = []) {
        self.spending = spending
        self.settings = settings
        self.payHistory = payHistory
        self.obligation = obligation
        self.recurring = recurring
        self.purchases = purchases
        self.lastLogonTerm = lastLogonTerm
        self.backups = backups
    }
    
    func getTotalAverage()->Int {
        if self.payHistory.count == 0 {
            return 0
        }
        
        var total = 0
        
        for history in self.payHistory {
            total += history.amount
        }
        
        let average = total / self.payHistory.count
        
        return average
    }
    
    func getYearAverage()->Int {
        var total = 0
        let yearAgo = Calendar.current.date(byAdding: .year, value: -1, to: Date())!
        
        for history in self.payHistory {
            if history.date > yearAgo {
                total += history.amount
            }
        }
        
        let average = total / settings.payTerm.amtInYear
        
        return average
    }
    
    func getMonthAverage()->Int {
        var total = 0
        var count = 0
        let monthAgo = Calendar.current.date(byAdding: .month, value: -1, to: Date())!
        
        for history in self.payHistory {
            if history.date > monthAgo {
                total += history.amount
                count += 1
            }
        }
        
        var average: Int
        if count > settings.payTerm.amtInMonth {
            average = total / count
        } else {
            average = total / settings.payTerm.amtInMonth
        }
        
        
        return average
    }
    
    mutating func addPay(data: History.Data)->Int {
        var history = History(data: data)
        var total = 0
        var collide = false
        
        history.term = Settings.termCalc(date: history.date, payTerm: settings.payTerm)
        
        for (index, savedHistory) in payHistory.enumerated() {
            if savedHistory.term == history.term {
                if savedHistory.isTerm {
                    payHistory[index].histories.append(history)
                    payHistory[index].amount += history.amount
                    payHistory[index].histories.sort {
                        $0.date < $1.date
                    }
                    collide = true
                } else {
                    let termDate = Settings.getDate(term: history.term, payTerm: settings.payTerm)
                    var newHistory = History(source: "\(settings.payTerm.singleName.capitalized) of \(termDate.transactionFormat)", amount: 0, date: termDate, term: history.term, isTerm: true, histories: [])
                    newHistory.addhistory(history: history)
                    newHistory.addhistory(history: savedHistory)
                    newHistory.histories.sort {
                        $0.date < $1.date
                    }
                    
                    payHistory[index] = newHistory
                    collide = true
                }
                break
            }
        }
        
        if !collide {
            payHistory.append(history)
        }
        payHistory.sort {
            $0.date < $1.date
        }

        let amount = Float(data.amount)
        
        var spenAmount = Int(amount * (Float(settings.spendSplit) / 100))
        total += spenAmount
        
        for (index, splittee) in settings.splits.enumerated() {
            let splitAmount = Int(amount * (Float(splittee.portion) / 100))
            total += splitAmount
            let newHistory = History(source: history.source + " Paycheck", amount: splitAmount, date: history.date)
            settings.splits[index].addTransaction(newHistory: newHistory)
        }
        
        let leftover = data.amount - total
        spenAmount += leftover
        total += leftover
        
        let newHistory = History(source: history.source + " Paycheck", amount: spenAmount, date: history.date)
        addPurchase(history: newHistory)
        
        return total
    }
    
    mutating func refactorHistory() {
        var newHistories: [History] = []
        var collide = false
        
        for history in payHistory {
            if history.isTerm {
                for nestHistory in history.histories {
                    var mutatedHistory = nestHistory
                    mutatedHistory.term = Settings.termCalc(date: mutatedHistory.date, payTerm: settings.payTerm)
                    
                    collide = false
                    for (index, newHistory) in newHistories.enumerated() {
                        if mutatedHistory.term == newHistory.term {
                            collide = true
                            if newHistory.isTerm {
                                newHistories[index].histories.append(mutatedHistory)
                                newHistories[index].amount += mutatedHistory.amount
                                newHistories[index].histories.sort {
                                    $0.date < $1.date
                                }
                            } else {
                                let termDate = Settings.getDate(term: mutatedHistory.term, payTerm: settings.payTerm)
                                var newTerm = History(source: "\(settings.payTerm.singleName.capitalized) of \(termDate.transactionFormat)", amount: 0, date: termDate, term: mutatedHistory.term, isTerm: true, histories: [])
                                newTerm.addhistory(history: mutatedHistory)
                                newTerm.addhistory(history: newHistory)
                                newTerm.histories.sort {
                                    $0.date < $1.date
                                }
                                
                                newHistories[index] = newTerm
                            }
                            break
                        }
                    }
                    if !collide {
                        newHistories.append(mutatedHistory)
                    }
                }
            } else {
                var mutatedHistory = history
                mutatedHistory.term = Settings.termCalc(date: mutatedHistory.date, payTerm: settings.payTerm)
                
                collide = false
                for (index, newHistory) in newHistories.enumerated() {
                    if mutatedHistory.term == newHistory.term {
                        collide = true
                        if newHistory.isTerm {
                            newHistories[index].histories.append(mutatedHistory)
                            newHistories[index].amount += mutatedHistory.amount
                            newHistories[index].histories.sort {
                                $0.date < $1.date
                            }
                        } else {
                            let termDate = Settings.getDate(term: mutatedHistory.term, payTerm: settings.payTerm)
                            var newTerm = History(source: "\(settings.payTerm.singleName.capitalized) of \(termDate.transactionFormat)", amount: 0, date: termDate, term: mutatedHistory.term, isTerm: true, histories: [])
                            newTerm.addhistory(history: mutatedHistory)
                            newTerm.addhistory(history: newHistory)
                            newTerm.histories.sort {
                                $0.date < $1.date
                            }
                            
                            newHistories[index] = newTerm
                        }
                        break
                    }
                }
                if !collide {
                    newHistories.append(mutatedHistory)
                }
            }
        }
        
        payHistory = newHistories
    }
    
    mutating func tallyRecur() {
        var total = 0
        
        for recur in recurring {
            total += recur.termCost
        }
        
        obligation = total
    }
    
    mutating func recurSortByName() {
        recurring.sort {
            $0.name < $1.name
        }
    }
    
    mutating func recurSortByCost() {
        recurring.sort {
            $0.cost < $1.cost
        }
    }
    
    mutating func recurSortByTermCost() {
        recurring.sort {
            $0.termCost < $1.termCost
        }
    }
    
    mutating func addRecurring(recur: Recurring) {
        recurring.append(recur)
        tallyRecur()
    }
    
    mutating func refactorRecurring() {
        for (index, _) in recurring.enumerated() {
            recurring[index].refactorTermCost(payTerm: settings.payTerm)
        }
        tallyRecur()
    }
    
    mutating func refactorPayTerm() {
        refactorHistory()
        refactorRecurring()
        lastLogonTerm = Settings.termCalc(date: Date(), payTerm: settings.payTerm)
    }
    
    mutating func addPurchase(history: History) {
        let category = Calendar.current.dateComponents([.month, .year], from: history.date)
        var collide = false
        
        for (index, savedHistory) in purchases.enumerated() {
            if Calendar.current.dateComponents([.month, .year], from: savedHistory.date) == category {
                
                purchases[index].histories.append(history)
                purchases[index].amount += history.amount
                purchases[index].histories.sort {
                    $0.date > $1.date
                }
                collide = true
                break
            }
        }
        
        if !collide {
            purchases.append(History(source: "n/a", amount: history.amount, date: history.date, term: 0, isTerm: true, histories: [history]))
        }
        purchases.sort {
            $0.date > $1.date
        }
        
        spending += history.amount
    }
    
    mutating func addPurchase(data: History.Data, isIn: Bool) {
        var mutable = data
        if !isIn {
            mutable.amount = -mutable.amount
        }
        let newHistory = History(data: mutable)
        
        addPurchase(history: newHistory)
    }
    
    mutating func subtractRecurring() {
        let term = Settings.termCalc(date: Date(), payTerm: settings.payTerm)
        let iterations = term - lastLogonTerm
        
        if iterations > 0 && obligation != 0 {
            for x in Range(0...iterations - 1) {
                let newHistory = History(source: "\(settings.payTerm.name.capitalized) Obligation", amount: -obligation, date: Settings.getDate(term: term - x, payTerm: settings.payTerm), term: term - x)
                addPurchase(history: newHistory)
            }
        }
        
        lastLogonTerm = term
    }
    
    mutating func newBackup() {
        let newBackup = backup
        backups.append(newBackup)
    }
    
    mutating func loadBackup(loadedBackup: Backup) {
        newBackup()
        update(from: loadedBackup)
    }
}

extension Budget {
    
    struct Data {
        var spending: Int = 0
        var settings: Settings = Settings(splits: [], spendSplit: 100, payTerm: .weekly)
        var payHistory: [History] = []
    }
    
    var data: Data {
        Data(spending: spending, settings: settings, payHistory: payHistory)
    }
    
    mutating func update(from data: Data) {
        spending = data.spending
        settings = data.settings
        payHistory = data.payHistory
    }
    
    var backup: Backup {
        Backup(spending: spending,
               settings: settings,
               payHistory: payHistory,
               obligation: obligation,
               recurring: recurring,
               purchases: purchases,
               lastLogonTerm: lastLogonTerm,
               backupDate: Date())
    }
    
    mutating func update(from backup: Backup) {
        spending = backup.spending
        settings = backup.settings
        payHistory = backup.payHistory
        obligation = backup.obligation
        recurring = backup.recurring
        purchases = backup.purchases
        lastLogonTerm = backup.lastLogonTerm
    }
    
}

extension History {
    static let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    struct Data {
        var source: String = ""
        var amount: Int = 0
        var date: Date = Date()
        var term: Int = Settings.termCalc(date: Date(), payTerm: .weekly)
//        var term: Int = 67
//        let numberFormatter: NumberFormatter
        
        func isEmpty()->Bool {
            if source.isEmpty || amount == 0 {
                return true
            }
            return false
        }
        
        init(source: String = "", amount: Int = 0, date: Date = Date()) {
            self.source = source
            self.amount = amount
            self.date = date
//            self.numberFormatter = NumberFormatter()
//            self.numberFormatter.numberStyle = .currency
//            self.numberFormatter.maximumFractionDigits = 2
        }
    }
    
    struct fauxData {
        var source: String
        var amount: Int
        var date: Date
        
        func isEmpty()->Bool {
            if source.isEmpty || amount == 0 {
                return true
            }
            return false
        }
        
        init(date: Date, source: String = "", amount: Int = 0) {
            self.source = source
            self.amount = amount
            self.date = date
        }
    }
    
    var data: Data {
        Data(source: source, amount: amount, date: date)
    }
    
    init(data: Data) {
        id = UUID()
        source = data.source
        amount = Int(data.amount)
        date = data.date
        term = data.term
        isTerm = false
        histories = []
    }
}

extension Recurring {
    struct Data {
        var name: String
        var term: RecurringTerm
        var cost: Int
        let numberFormatter: NumberFormatter
        
        func isEmpty()->Bool {
            if name.isEmpty || cost == 0 {
                return true
            }
            return false
        }
        
        init(name: String = "", term: RecurringTerm = .monthlyRecur, cost: Int = 0) {
            self.name = name
            self.term = term
            self.cost = cost
            self.numberFormatter = NumberFormatter()
            self.numberFormatter.numberStyle = .currency
            self.numberFormatter.maximumFractionDigits = 2
        }
    }
    
    var data: Data {
        Data(name: name, term: term, cost: cost)
    }
    
    init(data: Data, payTerm: PayTerm) {
        id = UUID()
        name = data.name
        term = data.term
        cost = data.cost
        termCost = (data.cost * data.term.amtInYear) / payTerm.amtInYear
    }
}

extension Budget {
    static let sampleData: Budget = Budget(spending: 0,
                                           settings: Settings(splits: [
                                            Splittee(name: "Savings", portion: 25, transferAmount: 0, history: [
//                                                History(source: "n/a", amount: 5000, date: Date(), term: 0, isTerm: true, histories: [
//                                                    History(source: "Federal Refund", amount: 5000, date: Date(), term: 0, isTerm: false, histories: [])
//                                                ])
                                            ]),
                                            Splittee(name: "Stocks", portion: 25, transferAmount: 0, history: [])
                                           ], spendSplit: 50, payTerm: .weekly),
                                           payHistory: [
//                                            History(source: "Gold Sachs", amount: 30, date: Calendar.current.date(byAdding: .year, value: -2, to: Date())!, term: PayTerm.termCalc(date: Calendar.current.date(byAdding: .year, value: -2, to: Date())!, payTerm: .weekly), isTerm: false, histories: []),
//                                            History(source: "Apple", amount: 20, date: Calendar.current.date(byAdding: .month, value: -2, to: Date())!, term: PayTerm.termCalc(date: Calendar.current.date(byAdding: .month, value: -2, to: Date())!, payTerm: .weekly), isTerm: false, histories: []),
//                                            History(source: "Microsoft", amount: 500, date: Date(), term: PayTerm.termCalc(date: Date(), payTerm: .weekly), isTerm: false, histories: [
//                                                History(source: "Tesl", amount: 250, date: Date(), term: PayTerm.termCalc(date: Date(), payTerm: .weekly), isTerm: false, histories: []),
//                                                History(source: "SpaceEks", amount: 250, date: Date(), term: PayTerm.termCalc(date: Date(), payTerm: .weekly), isTerm: false, histories: [])
//                                            ])
                                           ],
                                           obligation: 346,
                                           recurring: [
                                            Recurring(name: "Netflix", term: .monthlyRecur, cost: 1500, payTerm: .weekly)
                                           ],
                                           purchases: [
//                                            History(source: "n/a", amount: 30000, date: Date(), term: 0, isTerm: true, histories: [
//                                                History(source: "Hookers", amount: 20000, date: Date(), term: 0, isTerm: false, histories: []),
//                                                History(source: "Drugs", amount: 10000, date: Date(), term: 0, isTerm: false, histories: [])
//                                            ])
                                           ],
                                           lastLogonTerm: Settings.termCalc(date: Calendar.current.date(byAdding: .month, value: -2, to: Date())!, payTerm: .weekly),
                                           backups: [
                                            Budget().backup
                                           ]
    )
}
