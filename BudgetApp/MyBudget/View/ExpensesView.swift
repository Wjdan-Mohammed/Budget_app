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
    @State var expenseToCheck : NExpense 
    @State var showEditBudgetSheet: Bool = false
    //@State var total = 0
    var body: some View {
        NavigationStack {
            VStack {
                VStack(alignment: .leading){
                    if let financialData = financialData.last {
                        HStack{
                            if financialData.spendingStatus == "Over budget"{
                                Text("Over budget by \( abs(financialData.remaining), specifier: "%.0f")").foregroundStyle(.gray).font(.system(size: 14))
                            }
                            else{
                                Text("\( financialData.remaining, specifier: "%.0f") is left out of \(financialData.budget, specifier: "%.0f")").foregroundStyle(.gray).font(.system(size: 14))
                            }
                            Spacer()
                            Button("Edit") {
                                showEditBudgetSheet = true
                            }
                        }
                        
                        if financialData.spendingStatus == "Over budget"{
                            VStack(alignment: .leading){
                                ProgressView(value: financialData.total, total: financialData.budget).tint(.red).progressViewStyle(.linear)
                                HStack(spacing: 4){
                                    //                                    Image(systemName: "arrowtriangle.up.fill").foregroundStyle(Color.red) // Apply the desired color
                                    //                                        .font(.system(size: 10))
                                    Text("\(financialData.spendingStatus)").foregroundStyle(.red).font(.system(size: 12))
                                }
                            }
                        }
                        else if financialData.spendingStatus == "Under budget"{
                            VStack(alignment: .leading){
                                ProgressView(value: financialData.total, total: financialData.budget).tint(.green).progressViewStyle(.linear)
                                HStack(spacing: 4){
                                    //                                    Image(systemName: "arrowtriangle.down.fill").foregroundStyle(Color.green) // Apply the desired color
                                    //                                        .font(.system(size: 10))
                                    Text("\(financialData.spendingStatus) ").foregroundStyle(.green).font(.system(size: 12))
                                }
                            }
                        }
                        else if financialData.spendingStatus == "On budget"{
                            VStack(alignment: .leading){
                                ProgressView(value: financialData.total, total: financialData.budget).tint(.blue).progressViewStyle(.linear)
                                HStack(spacing: 4){
                                    //                                    Image(systemName: "square.fill").foregroundStyle(Color.blue) // Apply the desired color
                                    //                                        .font(.system(size: 10))
                                    Text("\(financialData.spendingStatus)").foregroundStyle(.blue).font(.system(size: 12))
                                }
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
                                if expense.checked == false{
                                    popoverPresented = true
                                    expense.checked = true
                                }
                                else {
                                    
                                    expense.checked.toggle()
                                    financialData.last!.total = 0
                                    for exp in expenses{
                                        if exp.StrAmountSpent != "0" && exp.StrAmountSpent != "0.0" && exp.checked == true{
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
                                }
                            }, label: {
                                //                                if expense.StrAmountSpent == "0" || expense.StrAmountSpent == "0.0" || expense.StrAmountSpent == "" {
                                if !expense.checked {
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
                                    else if Double(expense.cost) ?? 0 < (Double(expense.StrAmountSpent) ?? 0){
                                        Text("Over budget by \(Int(abs(Double(expense.cost)! - (Double(expense.StrAmountSpent) ?? 0))))").foregroundStyle(.gray).font(.system(size: 12))
                                    }
                                    else if Double(expense.cost) ?? 0 >= (Double(expense.StrAmountSpent) ?? 0){
                                        Text(String(Int(Double(expense.cost) ?? 0 - (Double(expense.StrAmountSpent) ?? 0)))).foregroundStyle(.gray).font(.system(size: 12))
                                        Text("left").foregroundStyle(.gray).font(.system(size: 12))
                                    }
                                }
                            }
                        }
                      
                        .onAppear(perform: {
                             expenseToEdit = expense
                        })
                        //                            .gesture(
                        //                                DragGesture()
                        //                                    .onChanged { gesture in
                        //
                        //                                    }
                        //                                    .onEnded { gesture in
                        //                                        withAnimation {
                        //                                           expenseToEdit = expense
                        //                                        }
                        //                                    }
                        //                            )
                        
                        .swipeActions(content: {
                            Button {
                                if let financialData = financialData.last{
                                    if expense.checked{
                                        financialData.remaining += Double(expense.cost) ?? 0
                                    }
                                }
                                modelContext.delete(expense)
                            } label: {
                                Image(systemName: "trash")
                            }.tint(.red)
                            
                        })
                        
                        .swipeActions(content: {
                            
                            Button {
                                print("🐙", expenseToEdit?.name)
                                expenseToEdit = expense
                                print("🐙🐙", expenseToEdit?.name)
                                print(expense.name)
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() ) {
                                    // your code here
                                    expenseToEdit = expense
                                    editViewPresented = true
                                }
                                
                            } label: {
                                Image(systemName: "pencil")
                                   
                            }
                            .tint(.blue)
                        }
                           
                        )
//                        .sheet(isPresented: $editViewPresented, content: {
//                            if let expenseToEdit = expenseToEdit {
//                                EditExpenseView(expense: expenseToEdit).presentationDetents([.fraction(0.4), .fraction(0.4), .fraction(0.4)])
//                            }
//                        })
                        
                        
                        //                        }
                    }
                    
                    //.onDelete(perform: deleteExpense)
                    //                    .swipeActions(content: {
                    //                        $expenseToEdit = expene
                    //                        Button {
                    //
                    //                            editViewPresented = true
                    //                        } label: {
                    //                            Image(systemName: "pencil")
                    //                        }.tint(.blue)
                    //                    }
                    //                    )
                    
                    .listRowSeparator(.hidden)
                    //                                            .sheet(item: $expenseToEdit){ expenseToEdit in
                    //                                                EditExpenseView(expense: expenseToEdit).presentationDetents([.medium])
                    //                                            }
                    .sheet(isPresented: $popoverPresented) {
                        //                                    //
                        
                        CheckExpenseView(expense: expenseToCheck).presentationDetents([.fraction(0.4), .fraction(0.4), .fraction(0.4)])
                    }
                    .sheet(isPresented: $showEditBudgetSheet) {
                        EditBudgetView()
                        .presentationDetents([.fraction(0.4), .fraction(0.4), .fraction(0.4)])
                        
                        
                    }
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
                    Button {
                        isActive = true
                    } label: {
                        HStack {
                            Image("add button")
                            Text("Add new expenses").foregroundStyle(.gray).font(.system(size: 14))
                        }
                    }.listRowSeparator(.hidden)
                }
                .sheet(isPresented: $editViewPresented, content: {
                    if let expenseToEdit = expenseToEdit {
                        EditExpenseView(expense: expenseToEdit).presentationDetents([.fraction(0.4), .fraction(0.4), .fraction(0.4)])
                    }
                })
                
//                .navigationDestination(for: NExpense.self) { expense in
//                    EditExpenseView(expense: expense)//.presentationDetents([.fraction(0.4), .fraction(0.4), .fraction(0.4)])
//                }
                //.navigationDestination(for: NExpense.self, destination: EditExpenseView.init)
                .listStyle(.plain)
                
            }.navigationTitle(Date().prettyMonth)
                //.navigationDestination(for: NExpense.self, destination: EditExpenseView.init)
//                .popover(isPresented: $editViewPresented, content: {
//                    EditExpenseView(expense: expenseToEdit).presentationDetents([.fraction(0.4), .fraction(0.4), .fraction(0.4)])
//                })
                .sheet(isPresented: $isActive){
                    AddExpenseView().presentationDetents([.fraction(0.4), .fraction(0.4), .fraction(0.4)])
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
                if exp.StrAmountSpent != "0" && exp.StrAmountSpent != "0.0" && exp.checked == true{
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
            if exp.StrAmountSpent != "0" && exp.StrAmountSpent != "0.0" && exp.checked == true{
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
