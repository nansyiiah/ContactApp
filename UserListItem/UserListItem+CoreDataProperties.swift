//
//  UserListItem+CoreDataProperties.swift
//  ContactApp
//
//  Created by Adrian K on 26/05/22.
//
//

import Foundation
import CoreData


extension UserListItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserListItem> {
        return NSFetchRequest<UserListItem>(entityName: "UserListItem")
    }

    @NSManaged public var firstName: String?
    @NSManaged public var mobilePhone: String?
    @NSManaged public var email: String?

}

extension UserListItem : Identifiable {

}
