//
//  Funtions.swift
//  Lab Test 2 App
//
//  Created by Omairys Uzcátegui on 2021-09-18.
//

import Foundation

let CoreDataSaveFailedNotification = Notification.Name(rawValue: "CoreDataSaveFailedNotification")

func fatalCoreDataError(_ error: Error) {
    print("*** Fatal error: \(error)")
    NotificationCenter.default.post(name: CoreDataSaveFailedNotification, object: nil)
}


