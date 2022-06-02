//
//  DataStoreManager.swift
//  Курсы валют KG
//
//  Created by Нагоев Магомед on 02.04.2022.
//

import Foundation
import CoreData


open class DataStoreManager {
    public static let modelName = "____________KG"
    public static let model: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: modelName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    public init() {
        
    }

    public lazy var mainContext: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    
    lazy var fetchedResultsController:NSFetchedResultsController<Rate> = {
        let fetchRequest: NSFetchRequest<Rate> = Rate.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let resultController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                managedObjectContext: mainContext,
                                                                sectionNameKeyPath: nil,
                                                                cacheName: nil)
        return resultController
    }()

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: DataStoreManager.modelName, managedObjectModel: DataStoreManager.model)
        container.loadPersistentStores { _, error in
          if let error = error as NSError? {
            fatalError("Unresolved error \(error), \(error.userInfo)")
          }
        }
        return container
      }()
    
    @discardableResult
    func addRate (name: String, amount: String) -> Rate {
        let rate = Rate(context: mainContext)
        rate.amount = amount
        rate.country = name
        saveContext(mainContext)
        return rate
    }

    func deleteRate(index: IndexPath) {
        let rate = fetchedResultsController.object(at: index)
        persistentContainer.viewContext.delete(rate)
        saveContext(mainContext)
    }

    func getRates() -> [Rate] {
        do {
            try fetchedResultsController.performFetch()
        } catch let error {
            print(error)
        }
        return fetchedResultsController.fetchedObjects!
    }
    
    
    // MARK: - Core Data Saving support
    public func newDerivedContext() -> NSManagedObjectContext {
        let context = persistentContainer.newBackgroundContext()
        return context
    }

//    public func saveContext() {
//      saveContext(mainContext)
//    }

    public func saveContext(_ context: NSManagedObjectContext) {
      if context != mainContext {
        saveDerivedContext(context)
        return
      }

      context.perform {
        do {
          try context.save()
        } catch let error as NSError {
          fatalError("Unresolved error \(error), \(error.userInfo)")
        }
      }
    }

    public func saveDerivedContext(_ context: NSManagedObjectContext) {
      context.perform {
        do {
          try context.save()
        } catch let error as NSError {
          fatalError("Unresolved error \(error), \(error.userInfo)")
        }

        self.saveContext(self.mainContext)
      }
    }
}
