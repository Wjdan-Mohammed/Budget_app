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
   // var expenses: [NExpense]?
    
    init(income: Double = 0, budget: Double = 0 ) {
        self.income = income
        self.budget = budget
   //     self.expenses = expenses
    }
    
}
