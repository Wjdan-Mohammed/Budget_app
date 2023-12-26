//
//  EditBudgetView.swift
//  MyBudget
//
//  Created by WjdanMo on 25/12/2023.
//

import SwiftUI
import SwiftData

struct EditBudgetView : View{
    @Environment(\.dismiss) var dismiss
    @State var textBudget = ""
    @Environment(\.modelContext) var modelContext
    @Query var financialData : [FinancialData]
    @Query var expenses : [NExpense]
    var body: some View {
        
        NavigationStack{
            VStack{
                Text("Edit your monthly budget").fontWeight(.bold).padding(.bottom)
                TextField("Your budget", text: $textBudget)
                    .padding(.leading, 18)
                    .font(.system(size: 14))
                    .frame(height: 40)
                    .frame(width: UIScreen.main.bounds.width-40,height: 44)
                    .background(Color(#colorLiteral(red: 0.1333329976, green: 0.1333335936, blue: 0.146202296, alpha: 1)))
                    .keyboardType(.numberPad)
                    .clipShape(.rect(cornerRadius: 10))
            }
            .toolbar {
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        
                        financialData.last!.budget = Double(helper.convertToEnglish(from: textBudget)) ?? 0
                        financialData.last!.total = 0
                        for exp in expenses{
                            if exp.StrAmountSpent != "0" && exp.StrAmountSpent != "0.0"{
                                financialData.last!.total += Double(exp.StrAmountSpent) ?? 0
                            }
                        }
                        //                if text != "0" && text != "0.0" && text != "00"{
                        //                    financialData.last!.total += Double(expense.StrAmountSpent) ?? 0
                        //                }
                        //                }
                        print("🌚", financialData.last!.total)
                        //            if let financialData = financialData.last{
                        financialData.last!.remaining = Double(financialData.last!.budget - financialData.last!.total)
                        print(financialData.last!.remaining)
                        
                        if financialData.last!.total > financialData.last!.budget {
                            financialData.last!.spendingStatus = "Over budget"
                            print("Over budget")
                        }
                        else if financialData.last!.total < financialData.last!.budget{
                            financialData.last!.spendingStatus = "Under budget"
                            print("Under budget")
                        }
                        else if financialData.last!.total == financialData.last!.budget{
                            financialData.last!.spendingStatus = "On budget"
                            print("On budget")
                        }
                        
                        dismiss()
                    }
                }
                
            }
        }
    }
}
