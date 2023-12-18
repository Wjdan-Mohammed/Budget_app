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
            VStack {
                Text("What is ur monthly income?").fontWeight(.bold).padding(.bottom, 20)
                TextField("Your income", text: $income)
                    .padding(.leading, 20)
                    .font(.system(size: 14))
                    .frame(height: 40)
                    .frame(width: UIScreen.main.bounds.width-40,height: 50)
                    .background(Color(#colorLiteral(red: 0.1333329976, green: 0.1333335936, blue: 0.146202296, alpha: 1))).clipShape(.rect(cornerRadius: 12))
                    .keyboardType(.numberPad)
                    .overlay(
                    HStack {
                        Spacer()
                        Text("SR")
                            .font(.system(size: 12))
                            .foregroundColor(Color("placeholder"))
                            .padding(.trailing, 20)
                    }, alignment: .trailing
                )
            
           
                Button{
                    addIncome()
                    isActive = true
                }label: {
                    Text("Next")
                        .font(.title3)
                        .foregroundColor(.white)
                        .frame(width: 170, height: 50)
                        .background(Color(.accent))
                        .cornerRadius(12)
                }.padding(.top, 26)
                Spacer()
            }.padding(.top, 60)
            .navigationDestination(isPresented: $isActive) {
                BudgetOnboardingView(financialData: financialData.last ?? FinancialData())
            }
        }.padding()
    }
    
    func addIncome(){
        modelContext.insert(FinancialData(income: Double(income) ?? 0.0))
    }
}



