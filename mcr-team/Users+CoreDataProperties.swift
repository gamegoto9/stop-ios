//
//  Users+CoreDataProperties.swift
//  mcr-team
//
//  Created by LIKIT on 2/2/2560 BE.
//  Copyright © 2560 LIKIT. All rights reserved.
//

import Foundation
import CoreData


extension Users {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Users> {
        return NSFetchRequest<Users>(entityName: "Users");
    }

    @NSManaged public var email: String?
    @NSManaged public var firebasetoken: String?
    @NSManaged public var fullname: String?
    @NSManaged public var id: Int16
    @NSManaged public var profileimage: String?
    @NSManaged public var teamid: Int16
    @NSManaged public var telephonenumber: String?
    @NSManaged public var username: String?
    @NSManaged public var usertype: Int16
    @NSManaged public var verifytype: Int16

}
