//
//  RepositoryProtocol.swift
//  CurrencyConverter
//
//  Created by rabin on 20/07/2022.
//


import Foundation
import CoreData

protocol Repository {
    associatedtype Object: Identifiable
    func fetch(with predicate: NSPredicate?) -> [Object]?
    func findOrCreate(with predicate: NSPredicate) -> NSManagedObject?
    func create(with entityObject: Object) throws
    func update(predicate: NSPredicate?, with entityObject: Object) throws
    func delete(dbContext: NSManagedObjectContext?,predicate: NSPredicate) throws
    func batchWrite(with entityObjects: [Object]) throws
    func currentContext() -> NSManagedObjectContext
    func clearRepository()
}

extension Repository {
    func findOrCreate(with predicate: NSPredicate) -> NSManagedObject? {
        return nil
    }
}

protocol EntityIdentifiable {
    static var entityName: String { get }
}

protocol NSManagedObjectUpdaterProtocol: Identifiable {
    associatedtype Entity : ObjectCreatorProtocol
    
    @discardableResult
    func updateObject(_ object: Entity, context: NSManagedObjectContext) -> Entity
    
    func createEntity(context: NSManagedObjectContext) -> Entity
}

protocol ObjectCreatorProtocol: NSManagedObject {
    associatedtype Object : NSManagedObjectUpdaterProtocol
    func createObject() -> Object
}
