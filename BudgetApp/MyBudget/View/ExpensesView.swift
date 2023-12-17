//
//  ExpensesView.swift
//  MyBudget
//
//  Created by WjdanMo on 16/12/2023.
//

import SwiftUI
import SwiftData

struct ExpensesView: View {
    @Environment(\.modelContext) var modelContext
    @Query var expenses : [NExpense]
    @State var isActive = false
    @State private var isPopoverPresented = false
    @State var expense = NExpense()
    
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(expenses){ expense in
                        VStack {
                            HStack{
                                Button(action: {
                                    //pop up
                                    self.expense = expense
                                    isPopoverPresented = true
                                }, label: {
                                    if expense.StrAmountSpent == "0" || expense.StrAmountSpent == "0.0" {
                                        Image("circle")
                                    }
                                    else{
                                        Image("Check")
                                    }
                                    
                                })
                                
                                Text(expense.emoji)
                                Text(expense.name)
                                Spacer()
                                if expense.StrAmountSpent == "0" || expense.StrAmountSpent == "0.0"{
                                    Text(String(expense.cost))}
                                else{
                                    Text(String(expense.StrAmountSpent))
                                }
                                Text("SR")
                            }
                            HStack{
                                ProgressView().progressViewStyle(.linear)
                                Spacer()
                                if expense.StrAmountSpent == "0" || expense.StrAmountSpent == "0.0"{
                                    Text(String(expense.cost)).foregroundStyle(.gray)
                                }
                                else{
                                    Text(String(Int(expense.cost - (Double(expense.StrAmountSpent) ?? 0)))).foregroundStyle(.gray)
                                }
                                Text("SR Left").foregroundStyle(.gray)
                            }
                        }
                    }
                }
                .navigationDestination(for: NExpense.self, destination: EditExpenseView.init)
                .listStyle(.inset)
                Button(action: {
                    isActive = true
                }, label: {
                    HStack {
                        Image("add button")
                        Text("add new expenses").foregroundStyle(.gray)
                    }})
                
                
            }.navigationTitle(Date().prettyMonth)
                .popover(isPresented: $isPopoverPresented, content: {
                    EditExpenseView(expense: expense)
                })
                .padding()
                .sheet(isPresented: $isActive, content: {
                    AddExpenseView()
                })
        }
    }
}


struct EditExpenseView: View {
    @Bindable var expense : NExpense
    
    var body: some View {
        VStack{
            HStack{
                TextField("Name", text: $expense.name)
            }
            Text("How much did you spent?")
            TextField("amount spent", text: $expense.StrAmountSpent)
            
        }.padding()
            .background(.clear)
    }
}
