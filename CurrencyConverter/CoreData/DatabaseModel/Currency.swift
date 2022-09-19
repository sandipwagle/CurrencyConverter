//
//  Currency.swift
//  CurrencyConverter
//
//  Created by rabin on  20/07/2022.
//


import Foundation
import CoreData

@objc(Currency)
class Currency : NSManagedObject {
    @NSManaged var rate: Float
    @NSManaged var code: String?
    @NSManaged var name: String?
}

extension Currency {
    
    struct Object: NSManagedObjectUpdaterProtocol, JsonConvertible {
        
        typealias Entity = Currency
        
        var id: String {
            code ?? ""
        }
        
        var rate: Float = 0
        let code: String?
        let name: String?
        
        @discardableResult
        func updateObject(_ object: Entity, context: NSManagedObjectContext) -> Entity {
            object.code = code
            object.rate = rate
            if name != nil {
                object.name = name
            }
            return object
        }
        
        func createEntity(context: NSManagedObjectContext) -> Entity {
            let entity = Entity(context: context)
            entity.code = code
            entity.rate = rate
            entity.name = name
            return entity
        }
        
    }
    
}

extension Currency: ObjectCreatorProtocol {
    func createObject() -> Object {
        Object(rate: rate, code: code, name: name)
    }
}



