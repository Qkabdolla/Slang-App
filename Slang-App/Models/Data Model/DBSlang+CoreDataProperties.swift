//
//  DBSlang+CoreDataProperties.swift
//  
//
//  Created by Мадияр on 4/15/20.
//
//

import Foundation
import CoreData


extension DBSlang {

    @nonobjc public class func fetchSlangesRequest() -> NSFetchRequest<DBSlang> {
        return NSFetchRequest<DBSlang>(entityName: "DBSlang")
    }

    @NSManaged public var author: String
    @NSManaged public var defid: Int64
    @NSManaged public var definition: String
    @NSManaged public var example: String
    @NSManaged public var permalink: String
    @NSManaged public var thumbsDown: Int64
    @NSManaged public var thumbsUp: Int64
    @NSManaged public var word: String
    @NSManaged public var writtenOn: Date

}

extension DBSlang: SlangRepresentable {
    var _thumbsUp: Int {
        return Int(thumbsUp)
    }
    
    var _thumbsDown: Int {
        return Int(thumbsDown)
    }
    
    var _writtenOn: Date {
        return writtenOn as! Date
    }
}
