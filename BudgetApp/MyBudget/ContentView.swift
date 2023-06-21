//
//  ContentView.swift
//  MyBudget
//
//  Created by WjdanMo on 28/05/2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.colorScheme) var colorScheme
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Expense.dateAdded, ascending: true)],
        animation: .default)
    private var expenses: FetchedResults<Expense>
    
    @State var totalExpenses = 0.0
    @State var expenseName = ""
    @State var cost = ""
    @State var position = 0
    
    @Binding var expensesHolder : [Expense]
    @State private var newValue = [Expense]()
    
    @State var expenceEditProcessGoing = false
    { didSet{ newValue = expensesHolder } }
    @State var costEditProcessGoing = false
    { didSet{ newValue = expensesHolder } }
    
    let onEditEnd: () -> Void
    
    public init(_ txt: Binding<[Expense]>, onEditEnd: @escaping () -> Void) {
        _expensesHolder = txt
        self.onEditEnd = onEditEnd
    }
    
    var body: some View {
        
        
        
        NavigationView{
            ZStack {
                Color("background color").ignoresSafeArea()
                
                //                ScrollView {
                VStack (alignment: .leading){
                    List{
                        Section{
                            ForEach(Array(zip(expenses.indices, expenses)), id: \.0) { i, expense in
                                HStack{
                                    Button(action: {
                                        if expense.isIncluded == false { includeExpense(expense, true) }
                                        else{ includeExpense(expense, false) }
                                        
                                    }, label: {
                                        Image(expense.isIncluded ? "checked" : "not-checked").scaledToFill()
                                        //                                            .padding(.horizontal, 0)
                                    })
                                    
                                    ZStack(alignment: .leading){
                                        if let name = expense.name{
                                            if !name.isEmpty{
                                                Text(expense.name!)
                                                    .opacity(expenceEditProcessGoing&&position == i ? 0 : 1)
                                                    .foregroundColor(colorScheme == .dark ? .white : .black)
                                                
                                                //                                        .foregroundColor(expense.name == nil ? .gray : (colorScheme == .dark ? .white : .black))
                                                    .frame(maxWidth: .infinity)
                                                    .frame(alignment: .leading)
                                                    .font(.system(size: 14))
                                                
                                                //                                                    .background(Color.blue)
                                                
                                            }
                                            else{
                                                
                                                Text("expense name")
                                                //                                        .opacity(expenceEditProcessGoing&&position == i ? 0 : 1)
                                                    .foregroundColor(.gray)
                                                    .frame(alignment: .leading)
                                                    .frame(maxWidth: .infinity)
                                                    .font(.system(size: 14))
                                                //                                                    .background(Color.yellow)
                                                
                                                
                                            }
                                        }
                                        else{
                                            Text("expense name")
                                            //                                    .opacity(expenceEditProcessGoing&&position == i ? 0 : 1)
                                                .foregroundColor(.gray)
                                                .frame(maxWidth: .infinity)
                                                .frame(alignment: .leading)
                                                .font(.system(size: 14))
                                            
                                            //                                                .background(Color.red)
                                            
                                        }
                                        
                                        if position==i {
                                            
                                            TextField("Expense Name", text: $expenseName,
                                                      onEditingChanged: { _ in },
                                                      onCommit: { self.expensesHolder = newValue; expenceEditProcessGoing = false; onEditEnd() } )
                                            .textFieldStyle(.roundedBorder)
                                            .font(.system(size: 14))
                                            
                                            .opacity(expenceEditProcessGoing ? 1 : 0)
                                            //                                    .frame(maxWidth: .infinity)
                                            .onSubmit {
                                                
                                                updateExpenseName(expense, expenseName)
                                                expenseName = ""
                                                expenceEditProcessGoing = false; newValue = self.expensesHolder
                                                
                                            }
                                            //                                            .background(Color.orange)
                                            
                                        }
                                    }
                                    
                                    .onTapGesture(perform: {
                                        
                                        if let name = expense.name { expenseName = name }
                                        self.cost = String(expense.cost)
                                        position = i
                                        expenceEditProcessGoing = true
                                    })
                                    Spacer()
                                    
                                    ZStack (alignment: .leading){
                                        
                                        if expense.cost != 0{
                                            Text(String(expense.cost) + " SR")
                                                .opacity(costEditProcessGoing&&position == i ? 0 : 1)
                                            //                                                .foregroundColor( colorScheme == .dark ? .white : .black )
                                                .foregroundColor( .gray )
                                            
                                                .frame(maxWidth: .infinity)
                                                .frame(alignment: .leading)
                                            //                                            .font(.system(size: 10))
                                                .font(.caption2)
                                            
                                        }
                                        else{
                                            Text("SAR")
                                                .opacity(costEditProcessGoing&&position == i ? 0 : 1)
                                                .foregroundColor( .gray )
                                                .frame(maxWidth: .infinity)
                                                .frame(alignment: .trailing)
                                            //                                            .font(.system(size: 10))
                                                .font(.caption2)
                                        }
                                        
                                        if position == i {
                                            TextField("Cost", text: $cost,
                                                      onEditingChanged: { _ in },
                                                      onCommit: { self.expensesHolder = newValue; costEditProcessGoing = false; onEditEnd() } )
                                            .textFieldStyle(.roundedBorder)
                                            .foregroundColor( .gray )
                                            .opacity(costEditProcessGoing ? 1 : 0)
                                            .frame(maxWidth: .infinity)
                                            //                                        .font(.system(size: 10))
                                            .font(.caption2)
                                            
                                            .onSubmit {
                                                
                                                updateCost(expense, cost)
                                                cost = ""
                                                costEditProcessGoing = false; newValue = self.expensesHolder
                                                print(expense)
                                                self.totalExpenses = expenses.map({$0.cost}).reduce(0, +)
                                                print(totalExpenses)
                                                
                                            }
                                        }
                                    }
                                    
                                    .onTapGesture(perform: {
                                        self.position = i
                                        costEditProcessGoing = true
                                        
                                    })
                                }.frame(alignment: .leading)
                                
                                    .listRowBackground(Color("background color"))
                                
                            }
                            .onDelete(perform: deleteItems)
                            HStack{
                                Button(action: { addExpense() }, label: {
                                    Image( "plus sign" ).scaledToFit()
                                })
                                Text("Add new expense")
                                    .foregroundColor( .gray )
                                //                                .font(.system(size: 10))
                                    .font(.caption2)
                                //                                .font(.Body)
                                //                            .foregroundColor(.grey)
                            }
                        }
                    header:{
                        
                    }
                    footer:{
                        HStack {
                            Text("under")
                                .font(.caption2)
                                .foregroundColor(.gray)
                            Spacer()
                            Text("Total expenses: " + String(totalExpenses))
                                .font(.caption2)
                                .foregroundColor(.gray)
                        }
                        
                        
                    }
                    .listSectionSeparatorTint(.clear)
                    }
                    .listStyle(.inset)
                    //                    .listRowInsets(.none)
                }
//                .toolbar {
//                    ToolbarItem(placement: .navigationBarTrailing) {
//                        EditButton()
//                    }
//                    ToolbarItem {
//                        Button(action: addExpense) {
//                            Label("Add Item", systemImage: "plus")
//                        }
//                    }
//                }
                //                }.padding()
                //                .background(Color.green)
                //                    .onAppear {
                //                      UITableView.appearance().backgroundColor = .clear
                //                    }
                //                    .onDisappear {
                //                      UITableView.appearance().backgroundColor = .systemGroupedBackground
                //                    }
            }
            //            .padding(.horizontal, 20)
            //            .background(Color(.clear))
        }
        //MARK: fix nav color
        .background(Color("background color"))
        .accentColor(.clear)
        .onAppear{
//            if let arr = expenses.first(where: { $0.isIncluded == true }){
//                print(arr)
            print("✅   ")
            print(expenses)
            for i in expenses{
                print(i.name)
            }
//                self.totalExpenses = arr.map({$0.cost}).reduce(0, +)
                
            }
            //            var arr = expenses.
            
            //            if let xp = arr{
            //                ForEach(expenses) { expense in
            //                self.totalExpenses = arr.map({$0.cost}).reduce(0, +)
            //                }
            //            }
//        }
        //        ForEachIndex(expenses) { i, expense in
        //            HStack{
        //                Button(action: {
        //
        //
        //                    //                    includedPosition = i
        //                    //                    expenses[i].isIncluded?.toggle()
        //                    //                    isIncluded.toggle()
        //
        //                    //                    print(expenses[i].isIncluded)
        //
        //                }, label: {
        //                    //                    if includedPosition == i {
        //                    Image(systemName: expense.isIncluded ? "checkmark.circle" : "circle")
        //                    //                    }
        //                    //                    else
        //                    //                    {
        //                    //
        //                    //                        Image(systemName: includeTag ? "checkmark.circle" : "circle")
        //                    //                    }
        //                })
        //
        //                ZStack(alignment: .leading){
        //
        //                    Text(expense.name ?? "expense name")
        //                        .opacity(expenceEditProcessGoing&&position == i ? 0 : 1)
        //                        .foregroundColor(expense.name == nil ? .gray : .black)
        //
        //                    if position == i {
        //                        TextField("expense name", text: $expenseName,
        //                                  onEditingChanged: { _ in },
        //                                  onCommit: { self.expenses = newValue; expenceEditProcessGoing = false; onEditEnd() } )
        //                        .textFieldStyle(.roundedBorder)
        //                        .opacity(expenceEditProcessGoing ? 1 : 0)
        //                        .onSubmit {
        //
        //                            expenses[i].name = expenseName
        //                            expenseName = ""
        //
        //                            expenceEditProcessGoing = false; newValue = self.expenses
        //
        //                        }
        //                    }
        //                }
        //
        //                .onTapGesture(perform: {
        //                    expenseName = expenses[i].name ?? ""
        //                    self.position = i
        //                    expenceEditProcessGoing = true
        //                } )
        //
        //                Spacer()
        //                ZStack (alignment: .leading){
        //                    // Text variation of View
        //                    Text(expense.cost ?? "cost name")
        //                        .opacity(costEditProcessGoing&&position == i ? 0 : 1)
        //                        .foregroundColor(expense.cost == nil ? .gray : .black)
        //
        //                    // TextField for edit mode of View
        //                    if position == i {
        //                        TextField("Cost", text: $cost,
        //                                  onEditingChanged: { _ in },
        //                                  onCommit: { self.expenses = newValue; costEditProcessGoing = false; onEditEnd() } )
        //                        .textFieldStyle(.roundedBorder)
        //                        .opacity(costEditProcessGoing ? 1 : 0)
        //                        .onSubmit {
        //                            //
        //                            expenses[i].cost = cost
        //                            cost = ""
        //                            costEditProcessGoing = false; newValue = self.expenses
        //
        //                            print(expenses)
        //
        //                        }
        //
        //                    }
        //                }
        //
        //
        //                // Enable EditMode on double tap
        //                .onTapGesture(perform: {
        //                    cost = expenses[i].cost ?? ""
        //                    self.position = i
        //                    costEditProcessGoing = true
        //
        //                } )
        //                // Exit from EditMode on Esc key press
        //
        //            }.onAppear{
        ////                includeTag = false
        //            }
        //        }
    }
    
    
    func includeExpense(_ expense : Expense , _ isIncluded: Bool){
        let isIncluded = isIncluded
        guard let expenseID = expense.id as? NSUUID else {return}
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Expense")
        fetchRequest.predicate = NSPredicate(format: "id == %@", expenseID as CVarArg)
        fetchRequest.fetchLimit = 1
        
        do {
            let test = try viewContext.fetch(fetchRequest)
            let expUpdate = test[0] as! NSManagedObject
            expUpdate.setValue(isIncluded, forKey: "isIncluded")
        } catch {
            print(error)
        }
    }
    func updateExpenseName(_ expense : Expense , _ name: String){
        let name = name
        guard let expenseID = expense.id as? NSUUID else {return}
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Expense")
        fetchRequest.predicate = NSPredicate(format: "id == %@", expenseID as CVarArg)
        fetchRequest.fetchLimit = 1
        
        do {
            let test = try viewContext.fetch(fetchRequest)
            let expUpdate = test[0] as! NSManagedObject
            expUpdate.setValue(name, forKey: "name")
            
        } catch {
            print("🆘")
        }
    }
    func updateCost(_ expense : Expense , _ cost: String){
        let cost = Double(cost)
        guard let expenseID = expense.id as? NSUUID else {return}
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Expense")
        fetchRequest.predicate = NSPredicate(format: "id == %@", expenseID as CVarArg)
        fetchRequest.fetchLimit = 1
        
        do {
            let test = try viewContext.fetch(fetchRequest)
            let expUpdate = test[0] as! NSManagedObject
            expUpdate.setValue(cost, forKey: "cost")
            
        } catch {
            print("🆘")
        }
    }
    
    
    // check the index or expense id b4 calling this or else it'll add a new expense when u want to update an existing one
    func addExpense(_ name : String?, _ cost : Double?, _ isIncluded : Bool) {
        let newTask = Expense(context: viewContext)
        newTask.id = UUID()
        newTask.isIncluded = isIncluded
        if let name = name { newTask.name = name }
        if let cost = cost { newTask.cost = cost }
        
        newTask.dateAdded = Date()
        do {
            try viewContext.save()
        } catch {
            print("error")
        }
    }
    
    
    
    
    private func addExpense() {
        costEditProcessGoing = true
        expenceEditProcessGoing = true
        
        position = expenses.endIndex
        withAnimation {
            let newItem = Expense(context: viewContext)
            
            newItem.id = UUID()
            newItem.dateAdded = Date()
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            print("-----",expenses)
            
            
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { expenses[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()


struct ForEachIndex<ItemType, ContentView: View>: View {
    let data: [ItemType]
    let content: (Int, ItemType) -> ContentView
    
    init(_ data: [ItemType], @ViewBuilder content: @escaping (Int, ItemType) -> ContentView) {
        self.data = data
        self.content = content
    }
    
    var body: some View {
        ForEach(Array(zip(data.indices, data)), id: \.0) { idx, item in
            content(idx, item)
                .background(Color.red)
        }
    }
}

//
//extension Expense : Sequence{
//
//}
