//
//  AddExpenseView.swift
//  MyBudget
//
//  Created by WjdanMo on 16/12/2023.
//

import SwiftUI
import SwiftData
import UIKit

struct AddExpenseView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query var expenses : [NExpense]
    @Query var financialData : [FinancialData]
    @State var expense = NExpense()
    @State var name = ""
    @State var cost = ""
    @State var nameEmpty = false
    @State var costEmpty = false
    @State var isActive = false
    @State var editingEmoji = false
    @State private var selectedEmoji: String = "💸"
    @State private var isEditing = false
    @State var inputValidationMsg = (false,"")
    @State var total = 0
    @State var disableBtn = false
    
    let emojis: [String] = ["💰", "🚗", "🏠", "🔌", "🛫", "📱", "🖥️", "🎮", "🍿", "🎧"]
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            VStack{
                VStack{
                    Text(isOnboarding ?? true ? "Add your expenses" : "Add your expense").fontWeight(.bold).padding(.bottom, 20)
                    HStack{
                                                Picker("", selection: $selectedEmoji) {
                                                    ForEach(emojis, id: \.self) { emoji in
                                                        Text(emoji).font(.system(size: 12)).tag(emoji)
                                                    }
                                                }
                        
                                                .pickerStyle(.menu)
                                                //                    .frame(height: 40)
                                                .frame(width: 60,height: 44)
                                                .background(Color(#colorLiteral(red: 0.1333329976, green: 0.1333335936, blue: 0.146202296, alpha: 1)))
                                                .clipShape(.rect(cornerRadius: 10))
                        
//                        TextFieldWrapperView(text: $selectedEmoji)
//                            .padding(.leading, 16)
//                            .frame(width: 60,height: 44)
//                            .background(Color(#colorLiteral(red: 0.1333329976, green: 0.1333335936, blue: 0.146202296, alpha: 1)))
//                            .clipShape(.rect(cornerRadius: 10))
//                            .overlay(
//                                HStack {
////                                    Spacer()
//                                    Text(editingEmoji ? "" : "Emoji")
//                                        .font(.system(size: 14))
//                                        .foregroundColor(Color(#colorLiteral(red: 0.3686269522, green: 0.3686279058, blue: 0.3900966644, alpha: 1)))
//                                        .padding(.leading, 12)
//                                }, alignment: .leading
//                            ).onTapGesture {
//                                editingEmoji = true
//                            }
                        TextField("Name", text: $name, onEditingChanged: { _ in
                            nameEmpty = false
                        })
                        .padding(.leading, 16)
                        .font(.system(size: 14))
                        .frame(width: isOnboarding ?? true ? UIScreen.main.bounds.width/2 - 20 :  UIScreen.main.bounds.width/3 ,height: 44)
                        .background(Color(#colorLiteral(red: 0.1333329976, green: 0.1333335936, blue: 0.146202296, alpha: 1)))
                        .clipShape(.rect(cornerRadius: 10))
                        
                        
                        TextField("Cost", text: $cost, onEditingChanged: { editing in
                            self.isEditing = editing
                            costEmpty = false
                        })
                        .padding(.leading, 16)
                        .font(.system(size: 14))
                        .frame(width: isOnboarding ?? true ? UIScreen.main.bounds.width/5 :  UIScreen.main.bounds.width/3 ,height: 44)
                        .background(Color(#colorLiteral(red: 0.1333329976, green: 0.1333335936, blue: 0.146202296, alpha: 1)))
                        .clipShape(.rect(cornerRadius: 10))
                        .keyboardType(.numberPad)
                        //                        .overlay(
                        //                            HStack {
                        //                                Spacer()
                        //                                Text("SR")
                        //                                    .font(.system(size: 12))
                        //                                    .foregroundColor(Color("placeholder"))
                        //                                    .padding(.trailing, 14)
                        //                            }, alignment: .trailing
                        //                        )
                        if isOnboarding ?? true{
                            Button {
                                if name.isEmpty && cost.isEmpty{
                                    
                                    nameEmpty = true
                                    costEmpty = true
                                    inputValidationMsg.0 = true
                                    inputValidationMsg.1 = "please write the expense name and cost"
                                }
                                else if cost.isEmpty{
                                    costEmpty = true
                                    inputValidationMsg.0 = true
                                    inputValidationMsg.1 = "please write the cost"
                                }
                                else if name.isEmpty{
                                    nameEmpty = true
                                    inputValidationMsg.0 = true
                                    inputValidationMsg.1 = "please write the name"
                                }
                                
                                else{
                                    inputValidationMsg.0 = false
                                    addExpense()
                                    
                                    
                                }
                                //                            if !expenses.isEmpty {
                                //                                disableBtn = false
                                //                            }
                            } label: {
                                Image("add button") .resizable().aspectRatio(contentMode: .fit).frame(width: 30, height: 30)
                            }
                        }
                        
                        
                    }
                    //                    if costEmpty&&nameEmpty{
                    if inputValidationMsg.0{
                        Text(inputValidationMsg.1).foregroundStyle(.red).font(.system(size: 14))
                    }
                    //                    }
                    //                    else if nameEmpty{
                    //                        Text("please write the expense name").foregroundStyle(.red).font(.system(size: 14))
                    //                    }
                    //                    else if costEmpty{
                    //                        Text("please write the expense cost").foregroundStyle(.red).font(.system(size: 14))
                    //                    }
                    
                    
                    //                    if isOnboarding ?? true{
                    //                        NavigationLink {
                    //                            ExpensesView()
                    //                        } label: {
                    //                            Button(action: {
                    //                                if isOnboarding ?? true{
                    //                                    isOnboarding = false
                    //
                    //                                    isActive = true
                    //                                }
                    //                                else{
                    //                                    self.presentationMode.wrappedValue.dismiss()
                    //                                }
                    //                            }) {
                    //                                Text("Done? Go next")
                    //                            }.padding(10)
                    //                        }
                    //                    }
                }//.padding()
                if isOnboarding ?? true {
                    ForEach(expenses){ expense in
                        HStack{
                            Text(expense.emoji)
                            Text(expense.name)
                                .font(.system(size: 14))
                            Spacer()
                            Text(expense.cost)
                                .font(.system(size: 14))
                            
                            Button(action: {
                                
                                //                            if !expenses.isEmpty {
                                //                                disableBtn = false
                                //                            }
                                //                            else{
                                //                                disableBtn = true
                                //                            }
                                
                                if let financialData = financialData.last{
                                    financialData.remaining += Double(expense.cost) ?? 0
                                }
                                modelContext.delete(expense)
                                //                            if expenses.isEmpty {
                                //                                disableBtn = true
                                //                            }
                            }, label: {
                                Image("Close Button").frame(width: 20,height: 20)
                            }).padding(.leading,16)
                        }.frame(alignment: .leading)
                    }.padding(.vertical, 10)
                        .padding(.top, 40)
                    // .padding(.horizontal)
                    Spacer()
                }
            }.toolbar {
                if !(isOnboarding ?? true) {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") { dismiss() }
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button{
                        if name.isEmpty && cost.isEmpty{
                            
                            nameEmpty = true
                            costEmpty = true
                            inputValidationMsg.0 = true
                            inputValidationMsg.1 = "please write the expense name and cost"
                        }
                        else if cost.isEmpty{
                            costEmpty = true
                            inputValidationMsg.0 = true
                            inputValidationMsg.1 = "please write the cost"
                        }
                        else if name.isEmpty{
                            nameEmpty = true
                            inputValidationMsg.0 = true
                            inputValidationMsg.1 = "please write the name"
                        }
                        
                        else{
                            inputValidationMsg.0 = false
                            addExpense()
                            self.presentationMode.wrappedValue.dismiss()
                            
                        }
                        if isOnboarding ?? true{
                            isOnboarding = false
                            
                            isActive = true
                        }
                        else{
                            //                            self.presentationMode.wrappedValue.dismiss()
                        }
                        //                                }) {
                        //                                    Text("Done? Go next")
                        //                                }.padding(10)
                        //                            }
                        //                        }
                    }label: {
                        Text(isOnboarding ?? true ? "Next" : "Add")
                        //                        Text(isOnboarding == true ? "Next" : "Save")
                        //                            .font(.title3)
                        //                            .foregroundColor(.white)
                        //                            .frame(width: 170, height: 50)
                        //                            .background(Color(.accent))
                        //                            .cornerRadius(12)
                    }
                }
                
            }
            
            .padding(.top, isOnboarding ?? true ? 100 : 0)
            .padding(.horizontal)
            .navigationTitle("")
        }
        .onAppear(perform: {
            //            if expenses.isEmpty {
            //                disableBtn = true
            //            }
        })
        .onDisappear(perform: {
            
            var total = 0
            for exp in expenses{
                total += Int(exp.StrAmountSpent) ?? 0
            }
            //            if let financialData = financialData.last{
            financialData.last!.remaining = Double(Int(financialData.last!.budget) - total)
            print(financialData.last!.remaining)
            
        })
    }
    
    func addExpense(){
        //        if !expenses.isEmpty {
        //            disableBtn = false
        //        }
        //        else{
        //            disableBtn = true
        //        }
        
        modelContext.insert(NExpense(name: name.isEmpty ? "": name,cost: helper.convertToEnglish(from: cost), StrAmountSpent: "",emoji: selectedEmoji))
        cost = ""
        name = ""
        //var total = 0
        for exp in expenses{
            total += Int(exp.StrAmountSpent) ?? 0
        }
        if let financialData = financialData.last{
            financialData.remaining = Double(Int(financialData.budget) - total)
            
        }
    }
}

struct TextFieldWrapperView: UIViewRepresentable {
    
    @Binding var text: String
    
    func makeCoordinator() -> TFCoordinator {
        TFCoordinator(self)
    }
}

extension TextFieldWrapperView {
    
    
    func makeUIView(context: UIViewRepresentableContext<TextFieldWrapperView>) -> UITextField {
        let textField = EmojiTextField()
        textField.delegate = context.coordinator
        return textField
    }
    
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        
    }
}

class TFCoordinator: NSObject, UITextFieldDelegate {
    var parent: TextFieldWrapperView
    
    init(_ textField: TextFieldWrapperView) {
        self.parent = textField
    }
    
    //        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    //            if let value = textField.text {
    //                parent.text = value
    //                parent.onChange?(value)
    //            }
    //
    //            return true
    //        }
}


class EmojiTextField: UITextField {
    
    // required for iOS 13
    override var textInputContextIdentifier: String? { "" } // return non-nil to show the Emoji keyboard ¯\_(ツ)_/¯
    
    override var textInputMode: UITextInputMode? {
        for mode in UITextInputMode.activeInputModes {
            if mode.primaryLanguage == "emoji" {
                return mode
            }
        }
        return nil
    }
}

