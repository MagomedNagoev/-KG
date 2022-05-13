//
//  Rate+CoreDataProperties.swift
//  Курсы валют KG
//
//  Created by Нагоев Магомед on 27.04.2022.
//
//

import Foundation
import CoreData


extension Rate {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Rate> {
        return NSFetchRequest<Rate>(entityName: "Rate")
    }

    @NSManaged public var amount: String?
    @NSManaged public var country: String?
    @NSManaged public var date: Date?

}

extension Rate : Identifiable {

}
