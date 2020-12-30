//
//  Photo+CoreDataProperties.swift
//  SiteInspectionBuddy
//
//  Created by Spencer Feng on 28/12/20.
//
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var photoData: Data?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var annotationData: Data?
    @NSManaged public var issue: Issue?

}

extension Photo : Identifiable {

}
