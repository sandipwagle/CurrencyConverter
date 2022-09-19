//
//  MockDb.swift
//  CurrencyConverterTests
//
//  Created by rabin on 22/07/2022.
//

import CoreData
@testable import CurrencyConverter

/// Database class to use
public class MockDatabase: DatabaseProtocol {
    
    //shared database
    public static let `default` = MockDatabase()

    /// The data stack
    public let dataStack: CoreDataStack
    
    /// the mainContext from Stack
    public lazy var mainContext: NSManagedObjectContext = { self.dataStack.mainContext }()
    
    /// the background context from Stack
    public lazy var bgContext: NSManagedObjectContext = { self.dataStack.bgContext }()
    
    
    
    /// initializer, that initialize the coreData stack with given model name
    init() {
        self.dataStack = AppDataStack(storeType: NSInMemoryStoreType)
    }
    
    func initalizaDB() {
        dataStack.setup {
            debugPrint("Data base initialized")
        }
    }
    
    func newBackgroundContext() -> NSManagedObjectContext {
        dataStack.newBackgroundContext()
    }
    
    func addObjectsInDB(context: NSManagedObjectContext) {
        context.performAndWait {
            let objects = Array(repeating: Currency.Object(rate: 100.1, code: "usd", name: "US Dollars"), count: 10)
            
            objects.forEach { object in
                _ = object.createEntity(context: context)
            }
            try? context.save()
        }
    }

}

