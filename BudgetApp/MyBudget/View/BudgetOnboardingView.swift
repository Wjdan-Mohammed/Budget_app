//
//  BudgetOnboardingView.swift
//  MyBudget
//
//  Created by WjdanMo on 16/12/2023.
//

import SwiftUI

struct BudgetOnboardingView: View {
    
    @Environment(\.modelContext) var modelContext
    @Bindable var financialData : FinancialData
    @State var budget = ""
    @State var isActive = false
//    @AppStorage("isOnboarding") var isOnboarding: Bool?
    
    var body: some View {
        NavigationStack{
            Text("What is ur monthly budget?")
            TextField("ur budget", text: $budget)
    
            VStack {
                Button("Next") {
                    addbudget()
                    
                    isActive = true
                }
                .padding()
                
                NavigationLink(
                    destination: AddExpenseView(),
                    isActive: $isActive,
                    label: { EmptyView() }
                )
            }
        }

    }
    
    func addbudget(){
        financialData.budget = Double(budget) ?? 0.00
        print("✨✨✨",financialData.income,", ", financialData.budget)
    }
}

//#Preview {
//    BudgetOnboardingView()
//}
