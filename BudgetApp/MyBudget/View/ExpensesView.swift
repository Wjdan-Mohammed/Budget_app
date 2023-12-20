//
//  ExpensesView.swift
//  MyBudget
//
//  Created by WjdanMo on 16/12/2023.
//

// arabic input
import SwiftUI
import SwiftData

struct ExpensesView: View {
    @Environment(\.modelContext) var modelContext
    @Query var expenses : [NExpense]
    @Query var financialData : [FinancialData]
    @State var isActive = false
    @State private var editViewPresented = false
    @State private var popoverPresented = false
    @State var expenseToEdit : NExpense?
    @State var expenseToCheck : NExpense = NExpense()
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(expenses){ expense in
                        VStack {
                            HStack{
                                Button(action: {
                                    //pop up
                                    
                                    self.expenseToCheck = expense
                                    popoverPresented = true
                                    //                                    CheckExpenseView(expense: expense)
                                }, label: {
                                    if expense.StrAmountSpent == "0" || expense.StrAmountSpent == "0.0" || expense.StrAmountSpent == "" {
                                        Image("circle")
                                    }
                                    else{
                                        Image("Check")
                                    }
                                    
                                })
                                
                                
                                
                                Text(expense.emoji)
                                Text(expense.name).font(.system(size: 14))
                                Spacer()
                                if expense.StrAmountSpent == "0" || expense.StrAmountSpent == "0.0" || expense.StrAmountSpent == ""{
                                    Text(expense.cost).font(.system(size: 14))
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
                                    Text(expense.cost).foregroundStyle(.gray).font(.system(size: 12))
                                }
                                else{
                                    Text(String(Int(Double(expense.cost)! - (Double(expense.StrAmountSpent) ?? 0)))).foregroundStyle(.gray).font(.system(size: 12))
                                }
                                Text("SR Left").foregroundStyle(.gray).font(.system(size: 12))
                            }
                        }
                        //                        .onTapGesture {
                        ////                            editViewPresented = true
                        //                        }
                    }.swipeActions(content: {
                        Button {
                            editViewPresented = true
                        } label: {
                            Image(systemName: "info.circle")
                        }
                    }
                    ).listRowSeparator(.hidden)
                    //                        .sheet(item: $expenseToEdit){ expenseToEdit in
                    //                            EditExpenseView(expense: expenseToEdit).presentationDetents([.medium])
                    //                        }
                        .alert("How much did you spent?", isPresented: $popoverPresented) {
                            //                                    //
                            
                            CheckExpenseView(expense: expenseToCheck).preferredColorScheme(.dark)
                        } message: {}
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
                
                
                .navigationDestination(for: NExpense.self) { expense in
                    EditExpenseView(expense: expense).presentationDetents([.medium])
                }
                //.navigationDestination(for: NExpense.self, destination: EditExpenseView.init)
                .listStyle(.plain)
                
            }.navigationTitle(Date().prettyMonth)
                .popover(isPresented: $editViewPresented, content: {
                    EditExpenseView(expense: expenseToCheck)
                })
                .padding(.top)
                .fullScreenCover(isPresented: $isActive){
                    AddExpenseView()
                }
            
        }.onAppear(perform: {
            var total = 0
            for exp in expenses{
                total += Int(exp.StrAmountSpent) ?? 0
            }
            //            if let financialData = financialData.last{
            financialData.last!.remaining = Double(Int(financialData.last!.budget) - total)
            print(financialData.last!.remaining)
            
            //            }
        }).navigationBarBackButtonHidden().navigationBarTitleDisplayMode(.large)
    }
}


struct EditExpenseView: View {
    @Environment(\.dismiss) var dismiss
    @Bindable var expense : NExpense
    let emojis: [String] = ["💰", "🚗", "🏠", "🔌", "🛫", "📱", "🖥️", "🎮", "🍿", "🎧"]

    
    var body: some View {
        NavigationStack{
            VStack{
            HStack{
                //                VStack{
                //Text("How much did you spent?").fontWeight(.bold).padding(.bottom, 20)
                //                    TextField("amount spent", text: $expense.StrAmountSpent)
                //                        .padding(.leading, 16)
                //                        .font(.system(size: 14))
                //                        .frame(width: UIScreen.main.bounds.width-40,height: 40)
                //                        .background(Color(#colorLiteral(red: 0.1333329976, green: 0.1333335936, blue: 0.146202296, alpha: 1)))
                //                        .clipShape(.rect(cornerRadius: 12))
                //                        .keyboardType(.numberPad)
                //                        .overlay(
                //                            HStack {
                //                                Spacer()
                //                                Text("SR")
                //                                    .font(.system(size: 12))
                //                                    .foregroundColor(Color("placeholder"))
                //                                    .padding(.trailing, 14)
                //                            }, alignment: .center
                //                        )
                //                    Spacer()
                Picker("", selection: $expense.emoji) {
                    ForEach(emojis, id: \.self) { emoji in
                        Text(emoji).font(.system(size: 12)).tag(emoji)
                    }
                }
                .pickerStyle(.menu)
                //                    .frame(height: 40)
                .frame(width: 60,height: 40)
                .background(Color(#colorLiteral(red: 0.1333329976, green: 0.1333335936, blue: 0.146202296, alpha: 1)))
                .clipShape(.rect(cornerRadius: 12))
                TextField("name", text: $expense.name)
                    .padding(.leading, 16)
                    .font(.system(size: 14))
                    .frame(width: UIScreen.main.bounds.width/3 ,height: 40)
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
                TextField("cost", text: $expense.cost)
                    .padding(.leading, 16)
                    .font(.system(size: 14))
                    .frame(width: UIScreen.main.bounds.width/3 ,height: 40)
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
                
            }
            .padding()
            .padding(.top, 60)
            .background(.clear)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { dismiss() }
                }
            }
                Spacer()
        }
        }
    }
}

struct CheckExpenseView: View {
    @Environment(\.dismiss) var dismiss
    @Query var expenses : [NExpense]
    @Query var financialData : [FinancialData]
    @Bindable var expense : NExpense
    
    
    var body: some View {
        VStack{
            TextField("amount spent", text: $expense.StrAmountSpent)
                .keyboardType(.numberPad)
            
            Button("Save", action: {
                var total = 0
                for exp in expenses{
                    total += Int(exp.StrAmountSpent) ?? 0
                }
                //            if let financialData = financialData.last{
                financialData.last!.remaining = Double(Int(financialData.last!.budget) - total)
                print(financialData.last!.remaining)
                
                dismiss()
            }).bold()
        }
    }
}
