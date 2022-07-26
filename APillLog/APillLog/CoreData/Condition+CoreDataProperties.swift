//
//  Condition+CoreDataProperties.swift
//  APillLog
//
//  Created by 종건 on 2022/07/17.
//
//

import Foundation
import CoreData


extension Condition {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Condition> {
        return NSFetchRequest<Condition>(entityName: "Condition")
    }

    @NSManaged public var createTime: Date?
    @NSManaged public var detailContext: String?
    @NSManaged public var dosage: [String]?
    @NSManaged public var id: UUID?
    @NSManaged public var medicinalEffect: [String]?
    @NSManaged public var name: [String]?
    @NSManaged public var sideEffect: [String]?

}

extension Condition : Identifiable {

}
