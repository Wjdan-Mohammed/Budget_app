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
    @State private var isEditing = false
    let emojis: [String] = ["💰", "🚗", "🏠", "🔌", "🛫", "📱", "🖥️", "🎮", "🍿", "🎧"]
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack{
                Text("What are your monthly expenses?").fontWeight(.bold).padding(.bottom, 20)
                HStack{
                    Picker("", selection: $selectedEmoji) {
                        ForEach(emojis, id: \.self) { emoji in
                            Text(emoji).font(.system(size: 12)).tag(emoji)
                        }
                    }
                    .pickerStyle(.menu)
                    //                    .frame(height: 40)
                    .frame(width: 60,height: 40)
                    .background(Color(#colorLiteral(red: 0.1333329976, green: 0.1333335936, blue: 0.146202296, alpha: 1)))
                    .clipShape(.rect(cornerRadius: 12))
                    TextField("Name", text: $name)
                        .padding(.leading, 16)
                        .font(.system(size: 14))
                        .frame(width: UIScreen.main.bounds.width/2,height: 40)
                        .background(Color(#colorLiteral(red: 0.1333329976, green: 0.1333335936, blue: 0.146202296, alpha: 1)))
                        .clipShape(.rect(cornerRadius: 12))
                    
                    TextField("Cost", text: $cost, onEditingChanged: { editing in
                        self.isEditing = editing
                    })
                    .padding(.leading, 16)
                    .font(.system(size: 14))
                    .frame(width: UIScreen.main.bounds.width/5,height: 40)
                    .background(Color(#colorLiteral(red: 0.1333329976, green: 0.1333335936, blue: 0.146202296, alpha: 1)))
                    .clipShape(.rect(cornerRadius: 12))
                    .keyboardType(.numberPad)
                    .overlay(
                        HStack {
                            Spacer()
                            if !isEditing{
                                Text("SR")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color("placeholder"))
                                    .padding(.trailing, 14)
                            }
                        }, alignment: .center
                    )
                    
                }
                //                Button("add", action: addExpense)
                Button{
                    if !name.isEmpty{ addExpense() }
                    else {
                        
                    }
                }label: {
                    Text("Add")
                        .font(.title3)
                        .foregroundColor(.white)
                        .frame(width: 170, height: 50)
                        .background(Color(.accent))
                        .cornerRadius(12)
                }.padding(.top, 26)
                
                    if isOnboarding ?? true{
                        NavigationLink {
                            ExpensesView()
                        } label: {
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
                            }.padding(10)
                        }
                    }
            }.padding()
                ForEach(expenses){ expense in
                    HStack{
                        Text(expense.emoji)
                        Text(expense.name)
                            .font(.system(size: 14))
                        Spacer()
                        Text(String(expense.cost))
                            .font(.system(size: 14))
                        Text("SR")
                            .font(.system(size: 14))
                        Button(action: {
                            modelContext.delete(expense)
                        }, label: {
                            Image("Close Button").frame(width: 20,height: 20)
                        }).padding(.leading,10)
                    }.frame(alignment: .leading)
                }.padding(.vertical, 6)
                    .padding(.horizontal)
                Spacer()
            }
        }
    }
    
    func addExpense(){
        modelContext.insert(NExpense(name: name.isEmpty ? "name": name,cost: Double(cost) ?? 0, StrAmountSpent: "0.0",emoji: selectedEmoji))
        cost = ""
        name = ""
    }
}

