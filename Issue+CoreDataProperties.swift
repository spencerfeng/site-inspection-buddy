//
//  Issue+CoreDataProperties.swift
//  SiteInspectionBuddy
//
//  Created by Spencer Feng on 29/11/20.
//
//

import Foundation
import CoreData
import UIKit

extension Issue {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Issue> {
        return NSFetchRequest<Issue>(entityName: "Issue")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var assignee: String?
    @NSManaged public var comment: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var project: Project?
    @NSManaged public var photos: NSSet?

    public var photosArray: [Photo] {
        let set = photos as? Set<Photo> ?? []
        
        return set.sorted {
            $0.createdAt! < $1.createdAt!
        }
    }
    
    public var firstPhoto: UIImage? {
        if photosArray.count <= 0 { return nil }
        
        guard let photoData = photosArray[0].photoData else { return nil }
        guard let image = UIImage(data: photoData) else { return nil }
        
        return image
    }
    
    public var annotationOfFirstPhoto: UIImage? {
        if photosArray.count <= 0 { return nil }
        
        guard let annotationData = photosArray[0].annotationData else { return nil }
        guard let annotation = UIImage(data: annotationData) else { return nil }
        
        return annotation
    }
}

// MARK: Generated accessors for photos
extension Issue {

    @objc(addPhotosObject:)
    @NSManaged public func addToPhotos(_ value: Photo)

    @objc(removePhotosObject:)
    @NSManaged public func removeFromPhotos(_ value: Photo)

    @objc(addPhotos:)
    @NSManaged public func addToPhotos(_ values: NSSet)

    @objc(removePhotos:)
    @NSManaged public func removeFromPhotos(_ values: NSSet)
    
}

extension Issue : Identifiable {

}
