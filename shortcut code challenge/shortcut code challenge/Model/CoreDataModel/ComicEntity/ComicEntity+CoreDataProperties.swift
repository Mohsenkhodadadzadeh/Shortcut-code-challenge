//
//  ComicEntity+CoreDataProperties.swift
//  shortcut code challenge
//
//  Created by Mohsen on 11/7/21.
//
//

import Foundation
import CoreData


extension ComicEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ComicEntity> {
        return NSFetchRequest<ComicEntity>(entityName: "ComicEntity")
    }

    @NSManaged public var comicDescription: String?
    @NSManaged public var imageData: Data?
    @NSManaged public var link: String?
    @NSManaged public var news: String?
    @NSManaged public var num: Int32
    @NSManaged public var publishedDate: Date?
    @NSManaged public var safeTitle: String?
    @NSManaged public var title: String?
    @NSManaged public var transcript: String?

}

extension ComicEntity : Identifiable {

}
