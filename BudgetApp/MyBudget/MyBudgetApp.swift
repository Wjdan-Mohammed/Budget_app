//
//  MyBudgetApp.swift
//  MyBudget
//
//  Created by WjdanMo on 28/05/2023.
//

import SwiftUI

@main
struct MyBudgetApp: App {
    let persistenceController = PersistenceController.shared

    @State var text = [Expense()]
    var body: some Scene {
        WindowGroup {
            ContentView($text, onEditEnd: { print("New name is * ") })
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
