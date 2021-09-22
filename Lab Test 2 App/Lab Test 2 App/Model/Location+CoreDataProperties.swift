//
//  Location+CoreDataProperties.swift
//  Lab Test 2 App
//
//  Created by Omairys Uzcátegui on 2021-09-18.
//
//

import Foundation
import CoreData
import CoreLocation


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var title: String?
    @NSManaged public var subtitle: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double

}

extension Location : Identifiable {

}
