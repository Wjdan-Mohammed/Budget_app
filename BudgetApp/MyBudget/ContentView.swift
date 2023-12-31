//
//  ContentView.swift
//  MyBudget
//
//  Created by WjdanMo on 28/05/2023.
//

import SwiftUI
import CoreData

extension Dictionary : RandomAccessCollection{
    public func index(before i: Index) -> Index {
        return i
    }
    
    
}
struct ContentView: View {
    @StateObject var vm = ExpenseViewModel()
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.colorScheme) var colorScheme
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Expense.dateAdded, ascending: false)],
        animation: .easeIn)
    private var expenses: FetchedResults<Expense>
    
    @State var totalExpenses = 0.0
    @State var expenseName = ""
    @State var cost = ""
    @State var position = 0
    @State var editedMonth = ""
    
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
            //            Collapsible {
            //                Text("hi")
            //            } content: {
            //                Text("hiiio")
            
            ZStack {
                Color("background color").ignoresSafeArea()
                
                //                ScrollView {
                VStack (alignment: .leading){
                    List{
                        
                        ForEach(expenses.groupedBy(dateComponents: [.month, .year]), id: \.key){ group in
                            DisclosureGroup {
                                Section{
                                    ForEach(Array(zip(group.value.indices, group.value)), id: \.0) { i, expense in
                                        HStack{
                                            Button(action: {
                                                if expense.isIncluded == false { includeExpense(expense, true) }
                                                else{ includeExpense(expense, false) }
                                                
                                            }, label: {
                                                Image(expense.isIncluded ? "checked" : "not-checked").resizable().frame(width: 26, height: 26, alignment: .center).scaledToFit()
                                                
                                            })
                                            
                                            ZStack(alignment: .leading){
//                                                if let name = expense.name{
                                                if expense.name != ""{
                                                        Text(expense.name!)
                                                            .opacity(expenceEditProcessGoing&&position == i&&editedMonth == group.key.prettyMonth ? 0 : 1)
                                                            .foregroundColor(colorScheme == .dark ? .white : .black)
                                                            .font(.custom("PlusJakartaSans-Medium", size:14))
                                                            .padding(.leading, 8)
                                                        
                                                        
                                                    }
                                                    else{

                                                        Text("expense name")
                                                            .foregroundColor(Color("mainGray"))
                                                            .font(.custom("PlusJakartaSans-Medium", size:14))
                                                            .padding(.leading, 8)
                                                    }
//                                                }
//                                                else{
//                                                    Text("expense name")
//                                                        .foregroundColor(Color("mainGray"))
//                                                        .font(.custom("PlusJakartaSans-Medium", size:14))
//                                                        .padding(.leading, 8)
//                                                }
                                                
                                                if position==i&&editedMonth == group.key.prettyMonth {
                                                    
                                                    TextField("Expense Name", text: $expenseName,
                                                              onEditingChanged: { _ in },
                                                              onCommit: { self.expensesHolder = newValue; expenceEditProcessGoing = false; onEditEnd() } )
                                                    .textFieldStyle(.roundedBorder)
                                                    .padding(.leading, 8)
                                                    .font(.custom("PlusJakartaSans-Medium", size:14))
                                                    
                                                    .opacity(expenceEditProcessGoing ? 1 : 0)
                                                    .onSubmit {
                                                        
                                                        updateExpenseName(expense, expenseName)
                                                        expenseName = ""
                                                        expenceEditProcessGoing = false; newValue = self.expensesHolder
                                                        
                                                    }
                                                }
                                            }
                                            //
                                            .onTapGesture(perform: {
                                                
                                                if let name = expense.name { expenseName = name }
                                                self.cost = String(expense.cost)
                                                position = i
                                                expenceEditProcessGoing = true
                                                editedMonth = group.key.prettyMonth
                                            })
                                            Spacer()
                                            //
                                            ZStack (alignment: .leading){
                                                
//                                                if expense.cost != nil{
                                                    Text(String(expense.cost) + " SR")
                                                        .opacity(costEditProcessGoing&&position == i&&editedMonth == group.key.prettyMonth ? 0 : 1)
                                                        .foregroundColor(Color("mainGray"))
                                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                                        .font(.custom("PlusJakartaSans-Medium", size:10))
                                                    
//                                                }
//                                                else{
//                                                    Text("SAR")
//                                                        .opacity(costEditProcessGoing&&position == i&&editedMonth == group.key.prettyMonth ? 0 : 1)
//                                                        .foregroundColor(Color("mainGray"))
//                                                        .font(.custom("PlusJakartaSans-Medium", size:10))
//                                                }
                                                
                                                if position == i&&editedMonth == group.key.prettyMonth {
                                                    TextField("Cost", text: $cost,
                                                              onEditingChanged: { _ in },
                                                              onCommit: { self.expensesHolder = newValue; costEditProcessGoing = false; onEditEnd() } )
                                                    .textFieldStyle(.roundedBorder)
                                                    .foregroundColor(Color("mainGray"))
                                                    .opacity(costEditProcessGoing ? 1 : 0)
                                                    .font(.custom("PlusJakartaSans-Medium", size:10))
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
                                            //
                                            .onTapGesture(perform: {
                                                if let name = expense.name { expenseName = name }
                                                self.cost = String(expense.cost)
                                                self.position = i
                                                costEditProcessGoing = true
                                                editedMonth = group.key.prettyMonth
                                            })
                                        }
                                        //                                    .frame(alignment: .leading)
                                        //                                    .listRowBackground(Color(.clear))
                                        
                                    }
                                    //MARK: end of 2nd ForEach
                                    .onDelete(perform: deleteItems)
                                    HStack(alignment: .center){
                                        Button(action: {
                                            
//                                            position = group.value.endIndex
                                            addExpense(group.key)
                                            print(" ☀️ \n",group.value, " ☀️ \n")

                                        }, label: {
                                            Image( "plus sign" ).scaledToFit()
                                        })
                                        Text("Add new expense")
                                            .foregroundColor(Color("mainGray"))
                                        //                                .font(.system(size: 10))
                                            .font(.custom("PlusJakartaSans-Medium", size:10))
                                            .padding(.leading, 8)
                                        //                                .font(.Body)
                                        //                            .foregroundColor(.grey)
                                    }.frame( alignment: .leading)
                                    //MARK: grouping func
                                    //                                Button {
                                    //                                    print("🚀🚀🚀")
                                    //                                    //                                    print( expenses.groupedBy([.year, .month]))
                                    //                                    print(expenses.groupedBy(dateComponents: [.year, .month]))
                                    //                                    //MARK: decending + print/display written month + make it start from same month not last day of the prev month
                                    //                                    //
                                    //
                                    //                                    expenses.groupedBy(dateComponents: [.year, .month]).forEach {
                                    //                                        print(" 📅 Date: ",$0.key.prettyMonth)
                                    //                                        $0.value.forEach {
                                    //                                            print("      👤 ",$0.dateAdded!.prettyMonth)
                                    //                                        }
                                    //                                    }
                                    //
                                    //                                } label: {
                                    //                                    Text("print grouped exp")
                                    //                                }
                                }
                            header:{
                                
                            }
                            footer:{
                                HStack {
                                    Text("under")
                                        .font(.caption2)
                                        .foregroundColor(Color("mainGray"))
                                    Spacer()
                                    Text("Total expenses: " + String(totalExpenses))
                                        .font(.custom("PlusJakartaSans-Regular", size:10))
                                        .font(.caption2)
                                        .foregroundColor(Color("mainGray"))
                                }
                                .padding(.vertical)
                                //                            .frame(width: UIScreen.main.bounds.width)
                                
                                
                            }
                            } label: {
                                HStack {
                                    Text(group.key.prettyMonth)
                                        .font(.custom("PlusJakartaSans-Medium", size:12))
                                        .padding(.leading, UIScreen.main.bounds.width/20)
                                        .foregroundColor(Color("mainGray"))
                                    Spacer()
                                    Image("upward_Icon")
                                }
                                
                            }
                            .listRowInsets(EdgeInsets(top: 0, // make the top 0 to remove the spacing
                                                      leading: 0,
                                                      bottom: 0,
                                                      trailing: 0))
                        }
                        
                        
                        
                        
                    }
                    .environment(\.defaultMinListRowHeight, 50)
                    //                    .listSectionSeparatorTint(.red, edges: .all)
                    //                    .frame(width: UIScreen.main.bounds.width)
                    .padding(.trailing)
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
            }.onAppear(perform: {
                
                if expenses.isEmpty {
                    addExpense(Date())
                    
                }
                
                //                addExpense(Date(timeIntervalSince1970: 879869695))
                self.totalExpenses = expenses.map({$0.cost}).reduce(0, +)
                print("🎢🎢🎢🎢")
                
                let groupedDict = Dictionary(grouping: expenses, by: { $0.dateAdded?.month })
                
                groupedDict
                    .sorted(by: { a, b in a.key! < b.key! })
                    .forEach {
                        print("-----🌞 \($0) 🌚-----")
                        $0.value.forEach {
                            print("\($0.dateAdded!.prettyMonth)")
                        }
                    }
            })
            //            .padding(.horizontal, 20)
            //            .background(Color(.clear))
            //        }
            //MARK: fix nav color
            .background(Color("background color"))
            .accentColor(.clear)
            .onAppear{
                //            if let arr = expenses.first(where: { $0.isIncluded == true }){
                //                print(arr)
                print("✅   ")
                print(expenses)
                //
                //                self.totalExpenses = arr.map({$0.cost}).reduce(0, +)
                
            }
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
            try viewContext.save()
            
        } catch {
            print("🆘")
        }
    }
    
    
    // check the index or expense id b4 calling this or else it'll add a new expense when u want to update an existing one
//    func addExpense(_ name : String?, _ cost : Double?, _ isIncluded : Bool) {
//        let newTask = Expense(context: viewContext)
//        newTask.id = UUID()
//        newTask.isIncluded = isIncluded
//        if let name = name { newTask.name = name }
//        if let cost = cost { newTask.cost = cost }
//
//        newTask.dateAdded = Date()
//        do {
//            try viewContext.save()
//        } catch {
//            print("error")
//        }
//    }
    
    
    
    
    private func addExpense(_ date : Date = Date()) {
        cost = ""
        expenseName = ""
//        costEditProcessGoing = true
//        expenceEditProcessGoing = true
        
//        position = array.endIndex
        withAnimation {
            let newItem = Expense(context: viewContext)
            newItem.id = UUID()
            newItem.dateAdded = date
//            newItem
            do {
                try viewContext.save()
                viewContext.refresh(newItem, mergeChanges: true)
                
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            print("-----",expenses)
            
            
        }
    }
    func fetchTools() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Expense")

            do {
                try viewContext.fetch(fetchRequest)
            } catch let error {
                print("Error fetching \(error)")
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
    //    func sort(_ arr :[Element])->[Element]{
    //        return arr.sorted(by: {$0.date > $1.date})
    //    }
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
//struct Collapsible<Content: View>: View {
//    @State var label: () -> Text
//    @State var content: () -> Content
//
//    @State private var collapsed: Bool = true
//
//    var body: some View {
//        VStack {
//            Button(
//                action: { self.collapsed.toggle() },
//                label: {
//                    HStack {
//                        self.label()
//                        Spacer()
//                        Image(systemName: self.collapsed ? "chevron.down" : "chevron.up")
//                    }
//                    .padding(.bottom, 1)
//                    .background(Color.white.opacity(0.01))
//                }
//            ).background(.orange)
//            .buttonStyle(PlainButtonStyle())
////            .padding()
//
//            VStack {
//                self.content()
//            }
//            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: collapsed ? 0 : .none)
//            .clipped()
//            .animation(.easeOut, value: 0)
//            .transition(.slide)
//        }
//    }
//}


extension Date {
    var year: Int { Calendar.current.dateComponents([.year], from: self).year ?? 0 }
}



extension Date {
    func addDays(_ days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: self)!
    }
    
    func addMonths(_ months: Int) -> Date {
        return Calendar.current.date(byAdding: .month, value: months, to: self)!
    }
    
    var month: Date {
        let calendar = Calendar.current
        return calendar.date(from: calendar.dateComponents([.month, .year], from: self))!
    }
    
    var prettyMonth: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        formatter.locale = Calendar.current.locale!
        
        return formatter.string(from: self)
    }
    
    var prettyDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        formatter.locale = Calendar.current.locale!
        
        return formatter.string(from: self)
    }
}


protocol Dated {
    var date: Date { get }
}

extension FetchedResults where Element: Dated {
    func groupedBy(dateComponents: Set<Calendar.Component>) -> [Date: [Element]] {
        let initial: [Date: [Element]] = [:]
        let groupedByDateComponents = reduce(into: initial) { acc, cur in
            let components = Calendar.current.dateComponents(dateComponents, from: cur.date)
            let date = Calendar.current.date(from: components)!
            let existing = acc[date] ?? []
//            existing.sort{>}
            acc[date] = existing + [cur]
        }
        return groupedByDateComponents
    }
    
    
}
extension Array where Element: Dated{
    
}
extension Expense : Dated{
    var date: Date {
        return dateAdded ?? Date()
    }
    
    
}
