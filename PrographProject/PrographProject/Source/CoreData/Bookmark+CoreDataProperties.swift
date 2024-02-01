//
//  Bookmark+CoreDataProperties.swift
//  PrographProject
//
//  Created by Dylan_Y on 2/2/24.
//
//

import Foundation
import CoreData


extension Bookmark {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Bookmark> {
        return NSFetchRequest<Bookmark>(entityName: "Bookmark")
    }

    @NSManaged public var id: String?
    @NSManaged public var url: String?
    @NSManaged public var detail: String?

}

extension Bookmark : Identifiable {

}
