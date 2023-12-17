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
    let emojis: [String] = ["💰", "🚗", "🏠", "🔌", "🛫", "📱", "🖥️", "🎮", "🍿", "🎧"]
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    @Environment(\.presentationMode) var presentationMode
    
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
                    TextField("Cost", text: $cost)
                }
                Button("add", action: addExpense)
                
                NavigationLink(destination: ExpensesView(), isActive: $isActive) {
                    Button(action: {
                        if isOnboarding ?? true{
                            isOnboarding = false
                            
                            isActive = true
                        }
                        else{
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }) {
                        Text("Done? Go next")
                    }
                }
                
                
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
            }.padding().onAppear(perform: {
                print(expenses)
            })
        }
    }
    
    func addExpense(){
        modelContext.insert(NExpense(name: name.isEmpty ? "name": name,cost: Double(cost) ?? 0, StrAmountSpent: "0.0",emoji: selectedEmoji))
        cost = ""
        name = ""
    }
}

