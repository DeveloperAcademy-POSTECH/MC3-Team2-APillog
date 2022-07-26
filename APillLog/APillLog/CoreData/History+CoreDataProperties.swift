//
//  History+CoreDataProperties.swift
//  APillLog
//
//  Created by 종건 on 2022/07/22.
//
//

import Foundation
import CoreData


extension History {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<History> {
        return NSFetchRequest<History>(entityName: "History")
    }

    @NSManaged public var createTime: Date?
    @NSManaged public var detailContext: String?
    @NSManaged public var dosage: String?
    @NSManaged public var dosages: [String]?
    @NSManaged public var id: UUID?
    @NSManaged public var isMainPill: Bool
    @NSManaged public var medicinalEffect: [String]?
    @NSManaged public var names: [String]?
    @NSManaged public var pillName: String?
    @NSManaged public var sideEffect: [String]?
    @NSManaged public var pillId: UUID?

}

extension History : Identifiable {

}
