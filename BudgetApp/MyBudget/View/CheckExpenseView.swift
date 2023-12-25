//
//  CheckExpenseView.swift
//  MyBudget
//
//  Created by WjdanMo on 25/12/2023.
//

import SwiftUI
import SwiftData

struct CheckExpenseView: View {
    @Environment(\.dismiss) var dismiss
    @Query var expenses : [NExpense]
    @Query var financialData : [FinancialData]
    @Bindable var expense : NExpense
    @State var text = ""
    
    var body: some View {
        NavigationStack{
            VStack{
                Text("How much did you spent?").fontWeight(.bold).padding(.bottom)
                TextField("amount spent", text: $text)
                    .padding(.leading, 18)
                    .font(.system(size: 14))
                    .frame(height: 40)
                    .frame(width: UIScreen.main.bounds.width-40,height: 44)
                    .background(Color(#colorLiteral(red: 0.1333329976, green: 0.1333335936, blue: 0.146202296, alpha: 1)))
                    .keyboardType(.numberPad)
                    .clipShape(.rect(cornerRadius: 10))
                
                //            Button("Cancel") {
                //                dismiss()
                //            }
                //            Button("Save", action: {
                //                //                if let financialData = financialData.last{
                //
                //                //                    financialData.last!.total = 0
                //                //                    for exp in expenses{
                //                //                        if exp.StrAmountSpent != "0" && exp.StrAmountSpent != "0.0"{
                //                //                            financialData.last!.total += Double(exp.StrAmountSpent) ?? 0
                //                //                        }
                //                //                    }
                //                if financialData.last!.total > financialData.last!.budget {
                //                    financialData.last!.spendingStatus = "Over budget"
                //                    print("Over budget")
                //                }
                //                else if financialData.last!.total < financialData.last!.budget{
                //                    financialData.last!.spendingStatus = "Under budget"
                //                    print("Under budget")
                //                }
                //                else if financialData.last!.total == financialData.last!.budget{
                //                    financialData.last!.spendingStatus = "On budget"
                //                    print("On budget")
                //                }
                //                print("✊🏻", financialData.last!.total)
                //
                //                print("✨", financialData.last!.total)
                //                //                }
                //
                //                print(text)
                //                expense.StrAmountSpent = helper.convertToEnglish(from: text)
                //                print(expense.StrAmountSpent)
                //                //                var total = 0
                //                //                for exp in expenses{
                //                financialData.last!.total = 0
                //                for exp in expenses{
                //                    if exp.StrAmountSpent != "0" && exp.StrAmountSpent != "0.0"{
                //                        financialData.last!.total += Double(exp.StrAmountSpent) ?? 0
                //                    }
                //                }
                //                //                if text != "0" && text != "0.0" && text != "00"{
                //                //                    financialData.last!.total += Double(expense.StrAmountSpent) ?? 0
                //                //                }
                //                //                }
                //                print("🌚", financialData.last!.total)
                //                //            if let financialData = financialData.last{
                //                financialData.last!.remaining = Double(financialData.last!.budget - financialData.last!.total)
                //                print(financialData.last!.remaining)
                //
                //                if financialData.last!.total > financialData.last!.budget {
                //                    financialData.last!.spendingStatus = "Over budget"
                //                    print("Over budget")
                //                }
                //                else if financialData.last!.total < financialData.last!.budget{
                //                    financialData.last!.spendingStatus = "Under budget"
                //                    print("Under budget")
                //                }
                //                else if financialData.last!.total == financialData.last!.budget{
                //                    financialData.last!.spendingStatus = "On budget"
                //                    print("On budget")
                //                }
                //                dismiss()
                //                text = ""
                //            }
                
                
                //            ).bold()
            }
            .padding(.horizontal)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        //                if let financialData = financialData.last{
                        
                        //                    financialData.last!.total = 0
                        //                    for exp in expenses{
                        //                        if exp.StrAmountSpent != "0" && exp.StrAmountSpent != "0.0"{
                        //                            financialData.last!.total += Double(exp.StrAmountSpent) ?? 0
                        //                        }
                        //                    }
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
                        print("✊🏻", financialData.last!.total)
                        
                        print("✨", financialData.last!.total)
                        //                }
                        
                        print(text)
                        expense.StrAmountSpent = helper.convertToEnglish(from: text)
                        print(expense.StrAmountSpent)
                        //                var total = 0
                        //                for exp in expenses{
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
                        text = ""
                        expense.checked = true
                    }
                }
            }
        }
        
    }
    
}
