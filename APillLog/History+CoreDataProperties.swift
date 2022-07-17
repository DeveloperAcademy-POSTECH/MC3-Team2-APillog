//
//  History+CoreDataProperties.swift
//  APillLog
//
//  Created by 종건 on 2022/07/17.
//
//

import Foundation
import CoreData


extension History {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<History> {
        return NSFetchRequest<History>(entityName: "History")
    }

    @NSManaged public var condition: Condition
    @NSManaged public var createTime: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var isMainPill: Bool
    @NSManaged public var pillName: String?

}

extension History : Identifiable {

}
