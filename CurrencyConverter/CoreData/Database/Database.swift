//
//  Database.swift
//  CurrencyConverter
//
//  Created by rabin on 20/07/2022.
//


import CoreData

public protocol DatabaseProtocol {
    var mainContext: NSManagedObjectContext { get set }
    var bgContext: NSManagedObjectContext { get set }
}

/// Database class to use
public class Database: DatabaseProtocol {
    
    //shared database
    public static let `default` = Database()

    /// The data stack
    public let dataStack: CoreDataStack
    
    /// the mainContext from Stack
    public lazy var mainContext: NSManagedObjectContext = { self.dataStack.mainContext }()
    
    /// the background context from Stack
    public lazy var bgContext: NSManagedObjectContext = { self.dataStack.bgContext }()
    
    /// initializer, that initialize the coreData stack with given model name
    private init() {
        self.dataStack = AppDataStack()
    }
    
    func initalizaDB() {
        dataStack.setup {
            debugPrint("Data base initialized")
        }
    }

}
