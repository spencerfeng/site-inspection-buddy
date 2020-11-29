//
//  Project+CoreDataProperties.swift
//  SiteInspectionBuddy
//
//  Created by Spencer Feng on 29/11/20.
//
//

import Foundation
import CoreData


extension Project {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Project> {
        return NSFetchRequest<Project>(entityName: "Project")
    }

    @NSManaged public var title: String?
    @NSManaged public var date: Date?
    @NSManaged public var client: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var issues: NSSet?

}

// MARK: Generated accessors for issues
extension Project {

    @objc(addIssuesObject:)
    @NSManaged public func addToIssues(_ value: Issue)

    @objc(removeIssuesObject:)
    @NSManaged public func removeFromIssues(_ value: Issue)

    @objc(addIssues:)
    @NSManaged public func addToIssues(_ values: NSSet)

    @objc(removeIssues:)
    @NSManaged public func removeFromIssues(_ values: NSSet)

}

extension Project : Identifiable {

}
