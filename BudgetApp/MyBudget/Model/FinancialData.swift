//
//  FinancialData.swift
//  MyBudget
//
//  Created by WjdanMo on 16/12/2023.
//

import Foundation
import SwiftData

@Model
class FinancialData {
    var income: Double
    var budget: Double
    var remaining: Double
    var total : Double
    var spendingStatus : String
    
    init(income: Double = 0, budget: Double = 0, remaining: Double = 0 , total : Double = 0,spendingStatus : String = "") {
        self.income = income
        self.budget = budget
        self.remaining = remaining
        self.total = total
        self.spendingStatus = spendingStatus
    }
    
}
