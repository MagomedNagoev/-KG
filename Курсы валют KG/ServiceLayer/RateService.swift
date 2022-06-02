//
//  RateService.swift
//  Курсы валют KG
//
//  Created by Нагоев Магомед on 19.04.2022.
//

import Foundation
import CoreData

protocol RateServiceProtocol {
    @discardableResult
    func addRate (name: String, amount: String) -> Rate
    func deleteRate(rate: Rate)
    func getRates() -> [Rate]?
}

class RateService: RateServiceProtocol {
    // MARK: Properties
    let managedObjectContext: NSManagedObjectContext
    let dataStoreManager: DataStoreManager
    
    // MARK: - Initializers
    public init(managedObjectContext: NSManagedObjectContext, dataStoreManager: DataStoreManager) {
        self.managedObjectContext = managedObjectContext
        self.dataStoreManager = dataStoreManager
    }
    
    @discardableResult
    public func addRate (name: String, amount: String) -> Rate {
        let rate = Rate(context: managedObjectContext)
        rate.date = Date()
        rate.amount = amount
        rate.country = name
        dataStoreManager.saveContext(managedObjectContext)
        return rate
    }
    
    
    func deleteRate(rate: Rate) {
        managedObjectContext.delete(rate)
        dataStoreManager.saveContext(managedObjectContext)
    }
    
    func getRates() -> [Rate]? {
        let rateFetch: NSFetchRequest<Rate> = Rate.fetchRequest()
        do {
            let rates = try managedObjectContext.fetch(rateFetch)
            return rates
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
        return nil
    }
}
