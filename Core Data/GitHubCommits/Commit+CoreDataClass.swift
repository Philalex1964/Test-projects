//
//  Commit+CoreDataClass.swift
//  GitHubCommits
//
//  Created by Aleksandar Filipov on 7/6/22.
//
//

import Foundation
import CoreData

@objc(Commit)
public class Commit: NSManagedObject {
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
            super.init(entity: entity, insertInto: context)
            print("Init called!")
        }
}
