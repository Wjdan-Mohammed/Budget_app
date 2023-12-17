//
//  IncomeOnboardingView.swift
//  MyBudget
//
//  Created by WjdanMo on 16/12/2023.
//

import SwiftUI
import SwiftData

struct IncomeOnboardingView: View {
    @Environment(\.modelContext) var modelContext
    @Query var financialData : [FinancialData]
    @State var income = ""
    @State var isActive = false
    
    var body: some View {
        NavigationStack{
            Text("What is ur monthly income?")
            TextField("ur income", text: $income)
    
            VStack {
                Button("Next") {
                    addIncome()
                    isActive = true
                }
                .padding()
                
                NavigationLink(
                    destination: BudgetOnboardingView(financialData: financialData.last ?? FinancialData()),
                    isActive: $isActive,
                    label: { EmptyView() }
                )
            }
        }.onAppear{

        }
    }
    
    func addIncome(){
        modelContext.insert(FinancialData(income: Double(income) ?? 0.0))
    }
}

#Preview {
    IncomeOnboardingView()
}
