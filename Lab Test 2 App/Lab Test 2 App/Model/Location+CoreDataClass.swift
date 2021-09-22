//
//  Location+CoreDataClass.swift
//  Lab Test 2 App
//
//  Created by Omairys Uzcátegui on 2021-09-18.
//
//

import Foundation
import CoreData
import MapKit

@objc(Location)
public class Location: NSManagedObject, MKAnnotation {
    
    public var coordinate: CLLocationCoordinate2D{
        return CLLocationCoordinate2DMake(latitude, longitude)
    }
}
