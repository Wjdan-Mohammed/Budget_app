//
//  Expense+CoreDataProperties.swift
//  MyBudget
//
//  Created by WjdanMo on 02/09/2023.
//
//

import Foundation
import CoreData


extension Expense {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Expense> {
        return NSFetchRequest<Expense>(entityName: "Expense")
    }

    @NSManaged public var cost: Double
    @NSManaged public var dateAdded: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var isIncluded: Bool
    @NSManaged public var name: String?

}

extension Expense : Identifiable {

}
