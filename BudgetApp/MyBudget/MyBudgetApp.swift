//
//  MyBudgetApp.swift
//  MyBudget
//
//  Created by WjdanMo on 28/05/2023.
//

import SwiftUI
import SwiftData

@main
struct MyBudgetApp: App {
//    let persistenceController = PersistenceController.shared
//
//    @State var text = [Expense()]
//    @AppStorage("isOnboarding") var isOnboarding: Bool = true
    let modelContainer: ModelContainer
//        
        init() {
            do {
                modelContainer = try ModelContainer(for:  FinancialData.self, NExpense.self)
            } catch {
                fatalError("Could not initialize ModelContainer")
            }
        }
    var body: some Scene {
        WindowGroup {
//            if isOnboarding{
//                IncomeOnboardingView()
//                
//            }
//            else{
                AddExpenseView()
//                ExpensesView()
//            }
            
//            ContentView($text, onEditEnd: { print("New name is * ") })
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        .modelContainer(for: NExpense.self)
    }
}
