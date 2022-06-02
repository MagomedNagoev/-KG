//
//  BalancesPresenter.swift
//  Курсы валют KGTests
//
//  Created by Нагоев Магомед on 30.05.2022.
//

import XCTest
import CoreData

@testable import Курсы_валют_KG

class MockBalancesView: BalancesViewProtocol {
    func success() {
    }
    
    func failure(error: Error) {
    }
    
    func labelRefresh() {
    }
}

class MockDataStoreManager: DataStoreManager {
    override  init() {
        super.init()
        
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType

        let container = NSPersistentContainer(
          name: DataStoreManager.modelName,
          managedObjectModel: DataStoreManager.model)
        container.persistentStoreDescriptions = [persistentStoreDescription]

        container.loadPersistentStores { _, error in
          if let error = error as NSError? {
            fatalError("Unresolved error \(error), \(error.userInfo)")
          }
        }
        
        persistentContainer = container
    }
}

class BalancesPresenterTest: XCTestCase {
    var index: Int = 0
    var view: BalancesViewProtocol!
    var valutes: [Valute]?
    var storeManager: DataStoreManager!
    var networkService: NetworkServiceProtocol!
    var router: RouterProtocol!
    var presenter: BalancesPresenterProtocol!
    var rateService: RateServiceProtocol!
    
    override func setUp() {
        super.setUp()
        storeManager = MockDataStoreManager()
        rateService = RateService(managedObjectContext: storeManager.mainContext, dataStoreManager: storeManager)
        networkService = MockNetworkService()
    }
    
    override func setUpWithError() throws {
        let tabBar = UITabBarController()
        let assembly = AsselderModelBuilder()
        router = Router(tabBarController: tabBar, assemblyBuilder: assembly)
        view = MockBalancesView()
    }
    
    override func tearDown() {
        super.tearDown()
        view = nil
        networkService = nil
        rateService = nil
        storeManager = nil
        presenter = nil
        router = nil
    }
    
    func testRootContextIsSavedAfterAddingRate() {
        let rate = storeManager.addRate(name: "Baz", amount: "100")
        let getRates = storeManager.getRates()
        
        XCTAssertNotNil(getRates)
        XCTAssertEqual(getRates.count, 1)
        XCTAssertEqual(getRates.first?.country, rate.country)

    }
    
    func testRootContextIsSavedAfterAddingReport() {
      let derivedContext = storeManager.newDerivedContext()
        rateService = RateService(managedObjectContext: derivedContext, dataStoreManager: storeManager)

      expectation(
        forNotification: .NSManagedObjectContextDidSave,
        object: storeManager.mainContext) { _ in
          return true
      }

      derivedContext.perform {
        let rate = self.rateService.addRate(name: "Baz", amount: "Bar")
        XCTAssertNotNil(rate)
      }

      waitForExpectations(timeout: 2.0) { error in
        XCTAssertNil(error, "Save did not occur")
      }
    }
    
    func testDeleteReport() {
        let rate = storeManager.addRate(name: "Baz", amount: "100")
        
        var getRates = storeManager.getRates()
        XCTAssertTrue(getRates.count == 1)
        XCTAssertTrue(rate.country == getRates.first?.country)
        
        storeManager.deleteRate(index: IndexPath(row: 0, section: 0))
        
        getRates = storeManager.getRates()
        
        XCTAssertTrue(getRates.isEmpty)
    }
    
    func testDeleteRateThrowPresenter() {
        presenter = BalancesPresenter(view: view, networkService: networkService, router: router, storeManager: storeManager)
        let rate = storeManager.addRate(name: "Baz", amount: "100")
        var getRates = presenter?.getRates()
        XCTAssertTrue(getRates?.count == 1)
        XCTAssertTrue(rate.country == getRates?.first?.country)
        
        presenter?.deleteRate(index: IndexPath(row: 0, section: 0))
        let rate2 = rateService.addRate(name: "1", amount: "2")
        rateService.deleteRate(rate: rate2)
        getRates = presenter?.getRates()
        XCTAssertTrue(getRates?.isEmpty ?? false)
    }
    func testUpdateRateThrowPresenter() {
        presenter = BalancesPresenter(view: view, networkService: networkService, router: router, storeManager: storeManager)
        let rate = storeManager.addRate(name: "Baz", amount: "100")
        rate.amount  = "200"
        rate.country = "Baf"
        presenter.saveRate()
        
        let updatedRate = rateService.getRates()?[0]
        XCTAssertTrue(updatedRate?.amount == "200")
        XCTAssertTrue(updatedRate?.country == "Baf")
    }

}
