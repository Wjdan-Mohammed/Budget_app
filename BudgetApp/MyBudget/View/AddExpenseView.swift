//
//  AddExpenseView.swift
//  MyBudget
//
//  Created by WjdanMo on 16/12/2023.
//

import SwiftUI
import SwiftData

struct AddExpenseView: View {
    @Environment(\.modelContext) var modelContext
    @Query var expenses : [NExpense]
    @Query var financialData : [FinancialData]
    @State var expense = NExpense()
    @State var name = ""
    @State var cost = ""
    @State var isActive = false
    @State private var selectedEmoji: String = "💰"
    let emojis: [String] = [
        "💰", "🚗", "🏠", "🔌", "🛫", "📱", "🖥️", "🎮", "🍿", "🎧"
        // ... add more emojis as needed
    ]
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("What are your monthly expenses")
                HStack{
                    Picker("💰", selection: $selectedEmoji) {
                        ForEach(emojis, id: \.self) { emoji in
                            Text(emoji).tag(emoji)
                        }
                    }
                    .pickerStyle(.menu)
                    TextField("Name", text: $name)
                    TextField("Cose", text: $cost)
                }
                Button("add", action: addExpense)
                
                NavigationLink(destination: ExpensesView(), isActive: $isActive) {
                    Button(action: {
                        isActive = true // Set isActive to trigger navigation
                    }) {
                        Text("Done? Go next")
                    }
                }
                
                
//                List{
                    ForEach(expenses){ expense in
                        HStack{
                            Text(expense.emoji)
                            Text(expense.name)
                            Spacer()
                            Text(String(expense.cost))
                            Text("SR")
                            Button(action: {
                                modelContext.delete(expense)
                            }, label: {
                                Image("Close Button").frame(width: 20,height: 20)
                            })
                        }
                    }
//                    .onDelete(perform: { indexSet in
//                        for i in indexSet{
//                            let expense = expenses[i]
//                            modelContext.delete(expense)
//                        }
//                    })
//                }
            }.onAppear(perform: {
                print(expenses)
            })
        }
    }
    
    func addExpense(){
        //        print(expenses)
        //        expense.cost = Double(cost) ?? 0
        //        expense.name = nameee
        //        cost = ""
        //        nameee = ""
        //        expenses.append(expense)
        modelContext.insert(NExpense(name: name.isEmpty ? "name": name,amount: Double(cost) ?? 0,emoji: selectedEmoji))
        cost = ""
        name = ""
        //        modelContext.insert(expense)
        //        print(expenses)
        //        print(expenses.count)
        
    }
}

