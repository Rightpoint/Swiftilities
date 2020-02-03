//
//  CoreDataTests.swift
//  Swiftilities
//
//  Created by Adam Tierney on 3/29/17.
//  Copyright © 2017 Raizlabs. All rights reserved.
//

import CoreData
import Swiftilities
import XCTest

private let modelName: String = "TestModel"

///  This file is currently not testable using Swift Package Manager, pending SE-0271.
///  When support is available, we should ship the .xcdatamodel as a SPM test resource.
///  https://github.com/apple/swift-evolution/blob/master/proposals/0271-package-manager-resources.md
class CoreDataTestCase: XCTestCase {

    var isLoaded: Bool = false
    var storeDescriptions: [PersistentStoreDescription] = [PersistentStoreDescription()]

    lazy var stack: CoreDataStack = { [unowned self] in
        let bundle = Bundle(for: CoreDataTestCase.self)
        let url = bundle.url(forResource: modelName, withExtension: "momd")!
        let model = NSManagedObjectModel(contentsOf: url)
        let stack = CoreDataStack(name: modelName, managedObjectModel: model!)
        return stack
    }()

    override func setUp() {
        if !isLoaded {
            let expectLoading = expectation(description: "load persistent stores")
            stack.loadPersistentStores(completionHandler: { _, _  in
                self.isLoaded = true
                expectLoading.fulfill()
            })
            waitForExpectations(timeout: 10, handler: nil)
        }

        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
        stack.deleteAllObjects()
    }

    func addObjects_ViewContext() throws {
        let cxt = stack.viewContext
        User.new(identifier: 1, firstName: "jane", lastName: "smith", context: cxt)
        User.new(identifier: 2, firstName: "leon", lastName: "johnson", context: cxt)
        Animal.new(identifier: 1, name: "🐯", context: cxt)
        Animal.new(identifier: 2, name: "🐅", context: cxt)

        try cxt.saveContextTree()

        let newContext = stack.newBackgroundContext()
        let userRequest = NSFetchRequest<User>(entityName: "User")
        let userCount = try newContext.count(for: userRequest)
        let animalRequest = NSFetchRequest<Animal>(entityName: "Animal")
        let animalCount = try newContext.count(for: animalRequest)

        XCTAssertEqual(userCount, 2)
        XCTAssertEqual(animalCount, 2)
    }

    func addObjects_BackgroundContext() throws {

        let expectSaving = expectation(description: "save in background")
        stack.performBackgroundTask({ (cxt) in
            User.new(identifier: 33, firstName: "sofia", lastName: "stein", context: cxt)
            User.new(identifier: 34, firstName: "vallery", lastName: "spotts", context: cxt)
            User.new(identifier: 20, firstName: "luis", lastName: "borges", context: cxt)
            Animal.new(identifier: 999, name: "🐳", context: cxt)
            Animal.new(identifier: 1000, name: "🐎", context: cxt)
        }, completion: { _ in
            //swiftlint:disable force_try
            let cxt = self.stack.viewContext
            let userRequest = NSFetchRequest<User>(entityName: "User")
            let userCount = try! cxt.count(for: userRequest)
            let animalRequest = NSFetchRequest<Animal>(entityName: "Animal")
            let animalCount = try! cxt.count(for: animalRequest)
            //swiftlint:enable force_try

            XCTAssertEqual(userCount, 3)
            XCTAssertEqual(animalCount, 2)
            expectSaving.fulfill()
        })

        waitForExpectations(timeout: 10, handler: nil)
    }

}

class CoreDataStackInMemoryTests: CoreDataTestCase {

    func testAddObjects_ViewContext() throws {
        try addObjects_ViewContext()
    }

    func testAddObjects_BackgroundContext() throws {
        try addObjects_BackgroundContext()
    }
}

class CoreDataStackSQLLiteTests: CoreDataTestCase {

    override func setUp() {
        if !isLoaded {
            let fileName = modelName.appending(".sqlite")
            let url = CoreDataStack.defaultDirectoryURL().appendingPathComponent(fileName)
            let description = PersistentStoreDescription(url: url, type: NSSQLiteStoreType)
            storeDescriptions = [description]
        }
        super.setUp()
    }

    func testAddObjects_ViewContext() throws {
        try addObjects_ViewContext()
    }

    func testAddObjects_BackgroundContext() throws {
        try addObjects_BackgroundContext()
    }
}

class CoreDataStackBinaryTests: CoreDataTestCase {

    override func setUp() {
        if !isLoaded {
            let fileName = modelName.appending(".bin")
            let url = CoreDataStack.defaultDirectoryURL().appendingPathComponent(fileName)
            let description = PersistentStoreDescription(url: url, type: NSBinaryStoreType)
            storeDescriptions = [description]
        }
        super.setUp()
    }

    func testAddObjects_ViewContext() throws {
        try addObjects_ViewContext()
    }

    func testAddObjects_BackgroundContext() throws {
        try addObjects_BackgroundContext()
    }
}

// MARK: - Helpers
extension User {
    @discardableResult
    static func new(identifier: Int64,
                    firstName: String,
                    lastName: String,
                    context: NSManagedObjectContext) -> User {

        let description = context.entity(forClass: User.self)
        let user = User(entity: description, insertInto: context)
        user.id = identifier
        user.firstName = firstName
        user.lastName = lastName
        return user
    }
}

extension Animal {
    @discardableResult
    static func new(identifier: Int64, name: String, context: NSManagedObjectContext) -> Animal {
        let description = context.entity(forClass: Animal.self)
        let animal = Animal(entity: description, insertInto: context)
        animal.id = identifier
        animal.name = name
        return animal
    }
}
