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
    
    var body: some View {
        NavigationStack{
            VStack{
                Text("What is ur monthly budget?").fontWeight(.bold).padding(.bottom, 20)
                TextField("Your budget", text: $budget)
                    .padding(.leading, 18)
                    .font(.system(size: 14))
                    .frame(height: 40)
                    .frame(width: UIScreen.main.bounds.width-40,height: 50)
                    .background(Color(#colorLiteral(red: 0.1333329976, green: 0.1333335936, blue: 0.146202296, alpha: 1)))
                    .clipShape(.rect(cornerRadius: 12)).overlay(
                        HStack {
                            Spacer()
                            Text("SR")
                                .font(.system(size: 12))
                                .foregroundColor(Color("placeholder"))
                                .padding(.trailing, 20)
                        }, alignment: .trailing
                    )
                
                VStack {
                    Button{
                        addbudget()
                        isActive = true
                    }label: {
                        Text("Next")
                            .font(.title3)
                            .foregroundColor(.white)
                            .frame(width: 170, height: 50)
                            .background(Color(.accent))
                            .cornerRadius(12)
                    }
                    .padding(.top, 10)
                        .padding()
                    
                }.navigationDestination(isPresented: $isActive) {
                    AddExpenseView()
                }
                Spacer()
            }
//            .padding(.top, 10)
        }.padding()
        
    }
    
    func addbudget(){
        financialData.budget = Double(budget) ?? 0.00
        print("✨✨✨",financialData.income,", ", financialData.budget)
    }
}
