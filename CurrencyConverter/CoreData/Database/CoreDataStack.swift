//
//  CoreDataStack.swift
//  CurrencyConverter
//
//  Created by rabin on 20/07/2022.
//


import CoreData

public enum CoreDataError: Error, Equatable, CustomStringConvertible {
    case invalidEntity(entityName: String)
    case unableToSaveData
    case bundleNotFound
    case objectModelNotFound
    case persistentStoreFailedToLoad
    case persistentContainerNotInitialized
    
    public var description: String {
        switch self {
        case .invalidEntity(let entityName):
            return "Invalid entity with name \"\(entityName)\""
        default: return ""
        }
    }
}

public typealias ContextSaveBlock = (_ saved: Bool, _ error: Error?) -> Void

/// Protocol for CoreDataStack
public protocol CoreDataStack {
    
    /// Intializer for CoreDataStack with given model file name
    ///
    /// - Parameter modelFileName: the fileName to use
    init(modelName: String, storeType: String)
    
    /// The main context
    var mainContext: NSManagedObjectContext { get set }
    
    /// The background context
    var bgContext: NSManagedObjectContext { get set }
    
    /// The persistent container
    var persistentContainer: NSPersistentContainer { get set }
    
    /// New background context
    func newBackgroundContext() -> NSManagedObjectContext
    
    //laodDatabase
    func setup(completion: @escaping () -> Void)
}

/// DataStack class
final class AppDataStack: CoreDataStack {
    
    // MARK: - Properties
    private let bundle: Bundle
    private let modelName: String
    private let storeType: String
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName, managedObjectModel: managedObjectModel)
        container.persistentStoreDescriptions = [storeDescription]
        return container
    }()
    
    // MARK: Initializers
    init(modelName: String = Constant.Database.dataModel, storeType: String = NSSQLiteStoreType) {
        self.bundle = Bundle(for: AppDataStack.self)
        self.modelName = modelName
        self.storeType = storeType
    }
    
    public func setup(completion: @escaping () -> Void) {
        loadPersistentStore {
            completion()
        }
    }
    
    // MARK: Main context
    final lazy var mainContext: NSManagedObjectContext = {
        let mainContext = self.persistentContainer.viewContext
        self.setConfigTo(context: mainContext)
        mainContext.automaticallyMergesChangesFromParent = true
        return mainContext
    }()
    
    // MARK: Background context
    final lazy var bgContext: NSManagedObjectContext = {
        let backgroundContext = self.persistentContainer.newBackgroundContext()
        setConfigTo(context: backgroundContext)
        return backgroundContext
    }()
    
    
    // MARK: NewBackground Context
    func newBackgroundContext() -> NSManagedObjectContext {
        let backgroundContext = persistentContainer.newBackgroundContext()
        setConfigTo(context: backgroundContext)
        return backgroundContext
    }
    
    // MARK: Set configuration to context
    private func setConfigTo(context: NSManagedObjectContext) {
        context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        context.shouldDeleteInaccessibleFaults = true
    }
    
    final lazy var managedObjectModel: NSManagedObjectModel = {
        guard let modelUrl = bundle.url(forResource: modelName, withExtension: "momd") else {
            fatalError("could not find managed object model in bundle")
        }
        return NSManagedObjectModel(contentsOf: modelUrl)!
    }()
    
    // MARK: Store description
     fileprivate lazy var storeDescription: NSPersistentStoreDescription = {
        let storeDescription = NSPersistentStoreDescription(url: storeFullURL)
        debugPrint("SQLITE FILE: ", storeFullURL)
        storeDescription.type = storeType
        storeDescription.shouldInferMappingModelAutomatically = true
        storeDescription.shouldMigrateStoreAutomatically = true
        return storeDescription
    }()
    
    // MARK: Store URL
    private lazy var storeFullURL: URL = {
        let modelFileNameWidExt = modelName + ".sqlite"
        guard let docDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { fatalError("Could not create store url") }
        return docDirectory.appendingPathComponent(modelFileNameWidExt)
    }()
}

extension AppDataStack {
    
    private func loadPersistentStore(completion: @escaping () -> Void) {
        self.persistentContainer.loadPersistentStores { description, error in
            guard error == nil else {
                fatalError("was unable to load store \(error!)")
            }
            completion()
        }
    }
    
}
