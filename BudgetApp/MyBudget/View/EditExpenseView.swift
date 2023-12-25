//
//  EditExpenseView.swift
//  MyBudget
//
//  Created by WjdanMo on 25/12/2023.
//

import SwiftUI

struct EditExpenseView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var expense : NExpense
    let emojis: [String] = ["💰", "🚗", "🏠", "🔌", "🛫", "📱", "🖥️", "🎮", "🍿", "🎧"]
    @State private var cost = ""
    
    @State private var editingEmoji = false
    
    
    var body: some View {
        NavigationStack{
            ZStack{
                //Rectangle().foregroundColor(Color.black).ignoresSafeArea()
                
                VStack{
                    Text("Edit expense").fontWeight(.bold).padding(.bottom)
                    HStack{
                        Picker("", selection: $expense.emoji) {
                            ForEach(emojis, id: \.self) { emoji in
                                Text(emoji).font(.system(size: 12)).tag(emoji)
                            }
                        }

                        .pickerStyle(.menu)
                        //                    .frame(height: 40)
                        .frame(width: 60,height: 44)
                        .background(Color(#colorLiteral(red: 0.1333329976, green: 0.1333335936, blue: 0.146202296, alpha: 1)))
                        .clipShape(.rect(cornerRadius: 10))
//                        TextFieldWrapperView(text: $expense.emoji)
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
                        TextField("name", text: $expense.name)
                            .padding(.leading, 16)
                            .font(.system(size: 14))
                            .frame(width: UIScreen.main.bounds.width/3 ,height: 44)
                            .background(Color(#colorLiteral(red: 0.1333329976, green: 0.1333335936, blue: 0.146202296, alpha: 1)))
                            .clipShape(.rect(cornerRadius: 10))
                        //                            .overlay(
                        //                                HStack {
                        //                                    Spacer()
                        //                                    Text("SR")
                        //                                        .font(.system(size: 12))
                        //                                        .foregroundColor(Color("placeholder"))
                        //                                        .padding(.trailing, 14)
                        //                                }, alignment: .center
                        //                            )
                        TextField("cost", text: $cost)
                            .padding(.leading, 16)
                            .font(.system(size: 14))
                            .frame(width: UIScreen.main.bounds.width/3 ,height: 44)
                            .background(Color(#colorLiteral(red: 0.1333329976, green: 0.1333335936, blue: 0.146202296, alpha: 1)))
                            .clipShape(.rect(cornerRadius: 10))
                            .keyboardType(.numberPad)
                        //                            .overlay(
                        //                                HStack {
                        //                                    Spacer()
                        //                                    Text("SR")
                        //                                        .font(.system(size: 12))
                        //                                        .foregroundColor(Color("placeholder"))
                        //                                        .padding(.trailing, 14)
                        //                                }, alignment: .center
                        //                            )
                        //                            .onAppear(perform: {
                        //                                cost = expense.cost
                        //                            })
                        
                    }
                    //.padding()
                    //                .padding(.top, 60)
                    .background(.clear)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") { dismiss() }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Save") {
                                print("expense.emoji")
                                print(expense.emoji)
                                print(expense.name)
                                expense.cost = helper.convertToEnglish(from: cost)
                                dismiss()
                            }
                        }
                    }
                    
                }//.padding()
            }
            
        }.background(.black)
    }
}

