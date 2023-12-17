//
//  Expense.swift
//  MyBudget
//
//  Created by WjdanMo on 16/12/2023.
//

import Foundation
import SwiftData

@Model
class NExpense{
    
    var name : String
    var cost : Double
    var dateAdded : Date
    var emoji : String
    
    init(name: String = "name", amount: Double = 0, dateAdded: Date = .now, emoji : String = "💰") {
        self.name = name
        self.cost = amount
        self.dateAdded = dateAdded
        self.emoji = emoji
    }
    
}

