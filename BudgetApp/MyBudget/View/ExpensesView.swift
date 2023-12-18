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
//                                    if expense.cost != 0{
//                                    if expense.cost > Double(expense.StrAmountSpent) ?? 0{
                                        Text(String(Int(expense.cost - (Double(expense.StrAmountSpent) ?? 0)))).foregroundStyle(.gray).font(.system(size: 12))
//                                    }
//                                    }
//                                    else{
//                                        Text(String(expense.cost)).foregroundStyle(.red)
//                                    }
                                }
                                Text("SR Left").foregroundStyle(.gray).font(.system(size: 12))
                            }
                        }
                    }
                    
                    NavigationLink {
                        AddExpenseView()
                    } label: {
                        HStack {
                            Image("add button")
                            Text("add new expenses").foregroundStyle(.gray)
                        }
                    }
                }
                .navigationDestination(for: NExpense.self, destination: EditExpenseView.init)
                .listStyle(.inset)
                
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
//            HStack{
//                TextField("Name", text: $expense.name)
//            }
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
//                        if !isEditing{
                            Text("SR")
                                .font(.system(size: 12))
                                .foregroundColor(Color("placeholder"))
                                .padding(.trailing, 14)
//                        }
                    }, alignment: .center
                )
            Spacer()
            
        }
        .padding()
        .padding(.top, 60)
            .background(.clear)
    }
}
