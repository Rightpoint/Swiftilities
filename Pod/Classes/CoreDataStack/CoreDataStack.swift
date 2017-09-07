//
//  CoreDataStack.swift
//  Swiftilities
//
//  Created by Adam Tierney on 3/29/17.
//  Copyright © 2017 Raizlabs. All rights reserved.
//

import CoreData
import Foundation

/// A replacement for the NSPersistent​Store​Description class from iOS 10
public struct PersistentStoreDescription {
    public var url: URL?
    public let type: String
    public var isReadOnly: Bool = false
    public var configuration: String?
    public private(set) var options: [String : NSObject] = [:]
    public var shouldAddStoreAsynchronously: Bool = false

    public mutating func setOption(_ option: NSObject?, forKey key: String) {
        options[key] = option
    }

    public init() {
        url = nil
        type = NSInMemoryStoreType
    }

    public init(url: URL, type: String = NSSQLiteStoreType) {
        self.url = url
        self.type = type
    }
}

/// A light weight  core data stack, modeled to swap in and out easily for NSPersistent​Container for
/// iOS 9 compatibility.
public class CoreDataStack {

    public let persistentStoreCoordinator: NSPersistentStoreCoordinator
    public let managedObjectModel: NSManagedObjectModel

    public var persistantStoreDescriptions: [PersistentStoreDescription]

    /// the main queue managed object context
    public let viewContext: NSManagedObjectContext

    /// The ultimate context, through which all others merge before persistent store
    private let rootSavingContext: NSManagedObjectContext

    /// Background queue for queuing background context jobs
    private let backgroundQueue = DispatchQueue(label: Constants.queueName)

    public convenience init(modelName name: String,
                            bundleId: String,
                            storeType type: String) {

        guard let bundle = Bundle(identifier: bundleId) else {
            fatalError("invalid bundle id provided: \(bundleId)")
        }

        let urlCandidate = bundle.url(forResource: name, withExtension: "momd") ??
            bundle.url(forResource: name, withExtension: "mom")

        guard let modelURL = urlCandidate else {
            fatalError("invalid model name provided: \(name)")
        }

        guard let model = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Model could not be loaded")
        }

        let url = CoreDataStack.url(forModelNamed: name, storeType: type)

        let description: PersistentStoreDescription
        if let url = url {
            description = PersistentStoreDescription(url: url, type: type)
        }
        else {
            description = PersistentStoreDescription()
        }

        self.init(name: name, managedObjectModel: model)

        self.persistantStoreDescriptions = [description]
    }

    public init(name: String, managedObjectModel model: NSManagedObjectModel) {

        self.managedObjectModel = model
        self.persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)

        let topLevelContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        topLevelContext.persistentStoreCoordinator = persistentStoreCoordinator
        let mainQueueContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        mainQueueContext.parent = topLevelContext

        self.viewContext = mainQueueContext
        self.rootSavingContext = topLevelContext
        self.persistantStoreDescriptions = [PersistentStoreDescription()]

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleContextSave),
            name: .NSManagedObjectContextDidSave, object: nil)
    }

    /// Loads the persistent stores asynchronously and reports the result through the provided block
    /// on the main queue.
    ///
    /// NOTE: if the description specifies `shouldAddStoreAsynchronously` as `true` the provided
    /// block is called asynchronously on the main queue. This differs from the implementation of
    /// NSPersistentContainer
    public func loadPersistentStores(
        completionHandler block: @escaping (PersistentStoreDescription, Error?) -> Void) {

        for desc in persistantStoreDescriptions {
            if desc.shouldAddStoreAsynchronously {
                backgroundQueue.async {
                    do {
                        try self.addPersistentStore(withDescription: desc)
                    }
                    catch {
                        block(desc, error)
                        return
                    }
                }

                DispatchQueue.main.async {
                    block(desc, nil)
                }
            }
            else {
                do {
                    try self.addPersistentStore(withDescription: desc)
                }
                catch {
                    block(desc, error)
                    return
                }
                block(desc, nil)
            }
        }
    }

    public func newBackgroundContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = rootSavingContext
        return context
    }

    /// Deletes all objects using the `viewContext` this wraps a call to
    /// `delete(objecctsMatching:on:)` and executes it synchronously.
    public func deleteAllObjects() {

        assert(Thread.current == Thread.main,
               "this operation uses the main queue managed object context")

        let allEntities = persistentStoreCoordinator.managedObjectModel.entities

        viewContext.performAndWait {
            allEntities.forEach {
                let req = NSFetchRequest<NSFetchRequestResult>(entityName: $0.name!)
                self.delete(objectsMatching: req, on: self.viewContext)
            }
        }
    }

    /// Deletes objects matching request on the specified context. If all PersistentStores managed
    /// by the persistentStoreCoordinator are of `NSSQLiteStoreType`, this call optimizes the
    /// operation by performing a `NSBatchDeleteRequest`
    public func delete(objectsMatching request: NSFetchRequest<NSFetchRequestResult>,
                       on context: NSManagedObjectContext) {
        do {
            if persistentStoreCoordinator.persistentStores
                .filter({ $0.type != NSSQLiteStoreType }).count == 0 {
                try batchDelete(matching: request, on: context)
            }
            else {
                try delete(matching: request, on: context)
            }
        }
        catch {
            print("error deleteing all objects: \(error)")
        }
    }

    public func performBackgroundTask(
        _ block: @escaping (NSManagedObjectContext) -> Void,
        completion: ((Error?) -> Void)?) {

        backgroundQueue.sync {
            let context = newBackgroundContext()
            context.performAndWait {
                let err: Error? = nil
                do {
                    block(context)
                    try context.saveContextTree()
                }
                catch {
                    print("error in perform on background ctxt: \(error)")
                }
                if let completion = completion {
                    DispatchQueue.main.async {
                        completion(err)
                    }
                }
            }
        }
    }

    // MARK: - Merging

    @objc func handleContextSave(notification: Notification) {
        guard let broadcastingContext = notification.object as? NSManagedObjectContext,
            broadcastingContext.persistentStoreCoordinator == viewContext.persistentStoreCoordinator
            else {
                return
        }

        viewContext.mergeChanges(fromContextDidSave: notification)
    }

    static public func defaultDirectoryURL() -> URL {
        return FileManager.default.urls(
            for: .libraryDirectory, in: .userDomainMask).last!
    }

    // MARK: - Private

    /// NOTE: batch delete is unavialble for some (non-sqllite) store types
    private func batchDelete(matching request: NSFetchRequest<NSFetchRequestResult>,
                             on context: NSManagedObjectContext) throws {
        // NOTE: this forwards directly to persistent store hence the merging changes.
        // because of this no notification will be produced.

        //swiftlint:disable:next line_length
        // https://developer.apple.com/library/content/featuredarticles/CoreData_Batch_Guide/BatchDeletes/BatchDeletes.html

        var aggregateIds: [NSManagedObjectID] = []
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        deleteRequest.resultType = .resultTypeObjectIDs
        let result = try context.execute(deleteRequest)
        guard let deleteResult = result as? NSBatchDeleteResult,
            let deletedIds = deleteResult.result as? [NSManagedObjectID] else {
                fatalError("Unexpected from context result when deleting objects")
        }

        aggregateIds.append(contentsOf: deletedIds)

        NSManagedObjectContext
            .mergeChanges(fromRemoteContextSave: [NSDeletedObjectsKey: aggregateIds],
                          into: [viewContext, rootSavingContext])
    }

    private func delete(matching request: NSFetchRequest<NSFetchRequestResult>,
                        on context: NSManagedObjectContext) throws {

        let objects = try context.fetch(request)
        guard let managedObjects = objects as? [NSManagedObject] else {
            fatalError("unable to cast fetched objects to managed objects...")
        }

        managedObjects.forEach { context.delete($0) }
        try context.saveContextTree()
    }

    private func addPersistentStore(withDescription desc: PersistentStoreDescription) throws {
        try persistentStoreCoordinator.addPersistentStore(ofType: desc.type,
                                                          configurationName: desc.configuration,
                                                          at: desc.url,
                                                          options: desc.options)
    }

    private static func url(forModelNamed name: String, storeType type: String) -> URL? {
        if type == NSSQLiteStoreType {
            let fileName = name.appending(".sqlite")
            return defaultDirectoryURL().appendingPathComponent(fileName)
        }
        else if type == NSBinaryStoreType {
            let fileName = name.appending(".bin")
            return defaultDirectoryURL().appendingPathComponent(fileName)
        }
        else {
            return nil
        }
    }
}

extension CoreDataStack {

    fileprivate struct Constants {
        static let queueName = "com.raizlabs.swiftilities.coreDataBackgroundQueue"
    }

    public enum DataError: Error, CustomStringConvertible {
        case managedObjectModelMissing(name: String)

        public var description: String {
            switch self {
            case .managedObjectModelMissing(let name):
                return "unable to load or locate managed object model with name: \(name)"
            }
        }
    }
}

extension NSManagedObjectContext {

    /// Conveniently get entitiy description for class
    public func entity(forClass cls: AnyClass) -> NSEntityDescription {
        guard let entities = persistentStoreCoordinator?.managedObjectModel.entities else {
            fatalError("attempting to retrieve an entity from an ambigous model")
        }

        let className = NSStringFromClass(cls)
        var entity: NSEntityDescription? = nil
        entities.forEach {
            if $0.managedObjectClassName == className {
                entity = $0
            }
        }

        guard let desc = entity else {
            fatalError("cannot find this model in this context")
        }
        return desc
    }

    /// saves this context and all parent contexts up the tree
    public func saveContextTree() throws {
        var currentContext: NSManagedObjectContext? = self
        while currentContext != nil {
            guard let context = currentContext else { return }

            try context.performThrowingTaskAndWait {
                if context.hasChanges {
                    try context.save()
                }
            }
            currentContext = context.parent
        }
    }

    public func performThrowingTaskAndWait(_ block: @escaping () throws -> Void) throws {
        var errorOut: Error? = nil
        performAndWait {
            do {
                try block()
            }
            catch {
                errorOut = error
            }
        }

        if let error = errorOut { throw error }
    }
}
