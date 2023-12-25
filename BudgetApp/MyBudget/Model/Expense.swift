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
    var cost : String
    var amountSpent : Double
    var StrAmountSpent : String
    var dateAdded : Date
    var emoji : String
    var checked : Bool
    
    init(name: String = "", cost: String = "", amountSpent: Double = 0, StrAmountSpent : String = "" , dateAdded: Date = .now, emoji : String = "💰" , checked : Bool = false) {
        self.name = name
        self.cost = cost
        self.amountSpent = amountSpent
        self.StrAmountSpent = StrAmountSpent
        self.dateAdded = dateAdded
        self.emoji = emoji
        self.checked = checked
    }
    
}
