//
//  NSManagedObject.swift
//  CurrencyConverter
//
//  Created by rabin on 20/07/2022.
//

import CoreData

extension NSManagedObject: EntityIdentifiable {
   public static var entityName: String {
        String(describing: self)
    }
}
