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
                        
                        
                        dismiss()
                    }
                }
                
            }
        }
    }
}
