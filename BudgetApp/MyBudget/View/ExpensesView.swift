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
    @Query var financialData : [FinancialData]
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
                                Text(expense.name).font(.system(size: 14))
                                Spacer()
                                if expense.StrAmountSpent == "0" || expense.StrAmountSpent == "0.0"{
                                    Text(String(expense.cost)).font(.system(size: 14))
                                }
                                else{
                                    Text(String(expense.StrAmountSpent)).font(.system(size: 14))
                                }
                                Text("SR")
                            }
                            HStack{
                                ProgressView().progressViewStyle(.linear)
                                Spacer()
                                if expense.StrAmountSpent == "0" || expense.StrAmountSpent == "0.0"{
                                    Text(String(expense.cost)).foregroundStyle(.gray).font(.system(size: 12))
                                }
                                else{
                                        Text(String(Int(expense.cost - (Double(expense.StrAmountSpent) ?? 0)))).foregroundStyle(.gray).font(.system(size: 12))
                                }
                                Text("SR Left").foregroundStyle(.gray).font(.system(size: 12))
                            }
                        }
                    }.listRowSeparator(.hidden)
                    if let financialData = financialData.last {
                        HStack{
                            Text("\( financialData.remaining, specifier: "%.0f") is left out of \(financialData.budget, specifier: "%.0f")").foregroundStyle(.gray).font(.system(size: 14))
                        }
                    }
                    NavigationLink {
                        AddExpenseView()
                    } label: {
                        HStack {
                            Image("add button")
                            Text("Add new expenses").foregroundStyle(.gray).font(.system(size: 14))
                        }
                    }.listRowSeparator(.hidden)
                }
                .navigationDestination(for: NExpense.self, destination: EditExpenseView.init)
                .listStyle(.plain)
                
            }.navigationTitle(Date().prettyMonth)
                .popover(isPresented: $isPopoverPresented, content: {
                    EditExpenseView(expense: expense)
                })
                .padding(.top)
                .fullScreenCover(isPresented: $isActive){
                    AddExpenseView()
                }
                
        }.navigationBarBackButtonHidden().navigationBarTitleDisplayMode(.large)
    }
}


struct EditExpenseView: View {
    @Bindable var expense : NExpense
    
    var body: some View {
        VStack{
            Text("How much did you spent?").fontWeight(.bold).padding(.bottom, 20)
            TextField("amount spent", text: $expense.StrAmountSpent)
                .padding(.leading, 16)
                .font(.system(size: 14))
                .frame(width: UIScreen.main.bounds.width-40,height: 40)
                .background(Color(#colorLiteral(red: 0.1333329976, green: 0.1333335936, blue: 0.146202296, alpha: 1)))
                .clipShape(.rect(cornerRadius: 12))
                .keyboardType(.numberPad)
                .overlay(
                    HStack {
                        Spacer()
                            Text("SR")
                                .font(.system(size: 12))
                                .foregroundColor(Color("placeholder"))
                                .padding(.trailing, 14)
                    }, alignment: .center
                )
            Spacer()
            
        }
        .padding()
        .padding(.top, 60)
            .background(.clear)
    }
}
