//
//  Bookmark+CoreDataProperties.swift
//  PrographProject
//
//  Created by Dylan_Y on 2/4/24.
//
//

import Foundation
import CoreData


extension Bookmark {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Bookmark> {
        return NSFetchRequest<Bookmark>(entityName: "Bookmark")
    }

    @NSManaged public var detail: String?
    @NSManaged public var id: String?
    @NSManaged public var url: String?
    @NSManaged public var username: String?
    @NSManaged public var image: Data?

}

extension Bookmark : Identifiable {

}
