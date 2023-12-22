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
    @State private var editViewPresented = false
    @State private var popoverPresented = false
    @State var expenseToEdit : NExpense?
    @State var expenseToCheck : NExpense = NExpense()
    //@State var total = 0
    var body: some View {
        NavigationStack {
            VStack {
                VStack(alignment: .leading){
                    if let financialData = financialData.last {
                        HStack{
                            Text("\( financialData.remaining, specifier: "%.0f") is left out of \(financialData.budget, specifier: "%.0f")").foregroundStyle(.gray).font(.system(size: 14))
                        }
                        ProgressView().progressViewStyle(.linear)
                        if financialData.spendingStatus == "Over budget"{
                            HStack(spacing: 4){
                                Image(systemName: "arrowtriangle.up.fill").foregroundStyle(Color.red) // Apply the desired color
                                    .font(.system(size: 10))
                                Text("\(financialData.spendingStatus)").foregroundStyle(.red).font(.system(size: 12))
                            }
                        }
                        else if financialData.spendingStatus == "Under budget"{
                            HStack(spacing: 4){
                                Image(systemName: "arrowtriangle.down.fill").foregroundStyle(Color.green) // Apply the desired color
                                    .font(.system(size: 10))
                                Text("\(financialData.spendingStatus) ").foregroundStyle(.green).font(.system(size: 12))
                            }
                        }
                        else if financialData.spendingStatus == "On budget"{
                            HStack(spacing: 4){
                                Image(systemName: "square.fill").foregroundStyle(Color.gray) // Apply the desired color
                                    .font(.system(size: 10))
                                Text("\(financialData.spendingStatus)").foregroundStyle(.gray).font(.system(size: 12))
                            }
                        }
                        //Text("\(financialData.spendingStatus) \(financialData.total)").font(.system(size: 14))
                        
                    }
                    
                }.padding(.horizontal)
                
                List {
                    ForEach(expenses){ expense in
//                        VStack {
                            HStack{
                                
                                
                                Button(action: {
                                    self.expenseToCheck = expense
                                    popoverPresented = true
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
                                
                                VStack(alignment: .trailing, spacing: 6){
                                    
                                    HStack{
                                        if expense.StrAmountSpent == "" {
                                            Text("0").font(.system(size: 14))
                                        }
                                        else if expense.StrAmountSpent == "0" || expense.StrAmountSpent == "0.0" {
                                            Text(expense.StrAmountSpent).font(.system(size: 14))
                                        }
                                        else{
                                            Text(String(expense.StrAmountSpent)).font(.system(size: 14))
                                        }
                                        
                                    }
                                    HStack{
                                        if expense.StrAmountSpent == "0" || expense.StrAmountSpent == "0.0"{
                                            Text(expense.cost).foregroundStyle(.gray).font(.system(size: 12))
                                            Text("left").foregroundStyle(.gray).font(.system(size: 12))

                                        }
                                        else if Double(expense.cost)! < (Double(expense.StrAmountSpent) ?? 0){
                                            Text("Over the budget by \(Int(abs(Double(expense.cost)! - (Double(expense.StrAmountSpent) ?? 0))))").foregroundStyle(.red).font(.system(size: 12))
                                        }
                                        else if Double(expense.cost)! >= (Double(expense.StrAmountSpent) ?? 0){
                                            Text(String(Int(Double(expense.cost)! - (Double(expense.StrAmountSpent) ?? 0)))).foregroundStyle(.gray).font(.system(size: 12))
                                            Text("left").foregroundStyle(.gray).font(.system(size: 12))
                                        }
                                    }
                                }
                            }.swipeActions(content: {
                                Button {
                                    if let financialData = financialData.last{
                                        financialData.remaining += Double(expense.cost) ?? 0
                                    }
                                    modelContext.delete(expense)
                                } label: {
                                    Image(systemName: "trash")
                                }.tint(.red)
                                
                            })
//                        }
                    }//.onDelete(perform: deleteExpense)
                    .swipeActions(content: {
                        
                        Button {
                            editViewPresented = true
                        } label: {
                            Image(systemName: "pencil")
                        }.tint(.blue)
                    }
                    )
                    
                    .listRowSeparator(.hidden)
                    //                        .sheet(item: $expenseToEdit){ expenseToEdit in
                    //                            EditExpenseView(expense: expenseToEdit).presentationDetents([.medium])
                    //                        }
                        .alert("How much did you spent?", isPresented: $popoverPresented) {
                            //                                    //
                            
                            CheckExpenseView(expense: expenseToCheck).preferredColorScheme(.dark)
                        } message: {}
//                    if let financialData = financialData.last {
//                        HStack{
//                            Text("\( financialData.remaining, specifier: "%.0f") is left out of \(financialData.budget, specifier: "%.0f")").foregroundStyle(.gray).font(.system(size: 14))
//                        }
//                    }
                    //                    if let financialData = financialData.last {
                    ////                        HStack{
                    ////                            if financialData.remaining >= 0{
                    ////                                Text("\( financialData.remaining, specifier: "%.0f") is left out of \(financialData.budget, specifier: "%.0f")").foregroundStyle(.gray).font(.system(size: 14))
                    ////                        }
                    ////                            else {
                    //////                                if financialData.remaining >= 0{
                    ////                                    Text("\( financialData.remaining, specifier: "%.0f") is left out of \(financialData.budget, specifier: "%.0f")").foregroundStyle(.red).font(.system(size: 14))
                    //////                            }
                    ////                            }
                    ////                        }
                    ////                        HStack{
                    //                            if financialData.total > 0 {
                    //                                Text("\( financialData.remaining, specifier: "%.0f") is left out of \(financialData.budget, specifier: "%.0f") ").foregroundStyle(.gray).font(.system(size: 14))
                    //                            }
                    //                        else{
                    //                            Text("You're over the budget \(financialData.total)").foregroundStyle(.red).font(.system(size: 14))
                    //                        }
                    ////                            else {
                    ////                                Text("Over the budget by \( (financialData.budget - financialData.remaining), specifier: "%.0f") ").foregroundStyle(.red).font(.system(size: 14))
                    ////                            }
                    ////                        }
                    //                    }
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
                .fullScreenCover(isPresented: $isActive){
                    AddExpenseView()
                }
            
        }
//        .padding()
            .onAppear(perform: {
//            var total = 0
//            for exp in expenses{
//                total += Int(exp.StrAmountSpent) ?? 0
                //                //var total = 0
                financialData.last!.total = 0
                for exp in expenses{
                    if exp.StrAmountSpent != "0" && exp.StrAmountSpent != "0.0"{
                        financialData.last!.total += Double(exp.StrAmountSpent) ?? 0
                    }
                }
                if financialData.last!.total > financialData.last!.budget {
                    financialData.last!.spendingStatus = "Over budget"
                }
                else if financialData.last!.total < financialData.last!.budget{
                    financialData.last!.spendingStatus = "Under budget"
                }
                else if financialData.last!.total == financialData.last!.budget{
                    financialData.last!.spendingStatus = "On budget"
                }
//                                                if let financialData = financialData.last{
                                        financialData.last!.remaining = Double(financialData.last!.budget - financialData.last!.total)
                //                    //print(financialData.last!.remaining)
//                                }
                //                //            }
//            }
            //            }
        }).navigationBarBackButtonHidden().navigationBarTitleDisplayMode(.large)
    }
    
    func deleteExpense(_ indexSet: IndexSet ){
        
        for i in indexSet{
            modelContext.delete(expenses[i])
        }
        financialData.last!.total = 0
        for exp in expenses{
            if exp.StrAmountSpent != "0" && exp.StrAmountSpent != "0.0"{
                financialData.last!.total += Double(exp.StrAmountSpent) ?? 0
            }
        }
        if financialData.last!.total > financialData.last!.budget {
            financialData.last!.spendingStatus = "Over budget"
        }
        else if financialData.last!.total < financialData.last!.budget{
            financialData.last!.spendingStatus = "Under budget"
        }
        else if financialData.last!.total == financialData.last!.budget{
            financialData.last!.spendingStatus = "On budget"
        }
    }
}


struct EditExpenseView: View {
    @Environment(\.dismiss) var dismiss
    @Bindable var expense : NExpense
    let emojis: [String] = ["💰", "🚗", "🏠", "🔌", "🛫", "📱", "🖥️", "🎮", "🍿", "🎧"]
    @State var cost = ""
    
    
    
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
                        .overlay(
                            HStack {
                                Spacer()
                                Text("SR")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color("placeholder"))
                                    .padding(.trailing, 14)
                            }, alignment: .center
                        )
                    TextField("cost", text: $cost)
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
                        .onAppear(perform: {
                            cost = expense.cost
                        })
                    
                }
                .padding()
                .padding(.top, 60)
                .background(.clear)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") { dismiss() }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            expense.cost = helper.convertToEnglish(from: cost)
                            dismiss()
                        }
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
    @State var text = ""
    
    var body: some View {
        VStack{
            TextField("amount spent", text: $text)
                .keyboardType(.numberPad)
            
            Button("Save", action: {
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
            }).bold()
        }
    }
    
}

struct helper{
    static func convertToEnglish(from arabic: String) -> String {
        let arabicNumerals: [Character: String] = ["٠": "0", "١": "1", "٢": "2", "٣": "3", "٤": "4", "٥": "5", "٦": "6", "٧": "7", "٨": "8", "٩": "9"]
        
        var englishEquivalent = ""
        for character in arabic {
            if let englishNumber = arabicNumerals[character] {
                englishEquivalent.append(englishNumber)
            } else {
                englishEquivalent.append(character)
            }
        }
        return englishEquivalent
    }
}
