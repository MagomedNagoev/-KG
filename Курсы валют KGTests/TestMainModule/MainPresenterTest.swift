//
//  ____________KGTests.swift
//  Курсы валют KGTests
//
//  Created by Нагоев Магомед on 18.03.2022.
//

import XCTest

@testable import Курсы_валют_KG

class MockView: MainViewProtocol {
    func success() {
    }
    
    func failure(error: Error) {
    }
    
    func calculateSums(numberCountry: String) {
    }
    
}

class MainPresenterTest: XCTestCase {
    var view: MockView!
    var presenter: MainPresenter!
    var networkService: NetworkServiceProtocol!
    var router: RouterProtocol!
    
    override func setUp() {
 
        
    }
    
    override func setUpWithError() throws {
        let tabBar = UITabBarController()
        let assembly = AsselderModelBuilder()
        router = Router(tabBarController: tabBar, assemblyBuilder: assembly)
        view = MockView()
    }
    
    override func tearDown() {
        view = nil
        networkService = nil
        presenter = nil
        router = nil
    }
    
    func testGetSuccessData() {
        let rates = Rates(buyRate: "1", sellRate: "1", dateStart: "2022-06-15 13:12:06")
        let valute = Valute(title: "Baz", titleAlias: "Bar", id: "1", rates: rates)
        let valutes = [valute,valute]
        let data = ["Bof" : valutes[0], "Bod" : valutes[1]]
        let allData = AllData(error: false, message: "Foo", data: data)
        var catchData: AllData?
        
        networkService = MockNetworkService(allData: allData)
        presenter = MainPresenter(view: view, networkService: networkService, router: router)
        presenter.valutes = valutes
        
        networkService?.getAllData { result in
            switch result {
            
            case .success(let allData):
                catchData = allData
            case .failure(let error):
                print(error)
            }
        }
        XCTAssertEqual(catchData?.data?.count, presenter.valutes?.count)
        XCTAssertNotEqual(catchData?.data?.count, 0)
        
    }
    
    func testCalculate() {
        let rates = Rates(buyRate: "1", sellRate: "2", dateStart: "2022-06-15 13:12:06")
        let valute = Valute(title: "Baz", titleAlias: "Bar", id: "1", rates: rates)
        let valutes = [valute,valute]
        let data = ["Bof" : valutes[0], "Bod" : valutes[1]]
        let allData = AllData(error: false, message: "Foo", data: data)
        
        networkService = MockNetworkService(allData: allData)
        presenter = MainPresenter(view: view, networkService: networkService, router: router)
        presenter.valutes = valutes
        
        let sum = presenter.calculate(amountString: "100", fromCountry: 0, toCountry: 1, viewCountry: "First")
        let sum1 = presenter.calculate(amountString: "100", fromCountry: 0, toCountry: 1, viewCountry: "Second")
        let sumDouble = sum.removeFormatAmount()
        let sum1Double = sum1.removeFormatAmount()
        XCTAssertNotNil(sum)
        XCTAssertNotEqual(sumDouble, 0.0)
        XCTAssertEqual(sumDouble, 50.0)
        
        XCTAssertNotNil(sum1)
        XCTAssertNotEqual(sum1Double, 0.0)
        XCTAssertEqual(sum1Double, 200.0)
    }
    
    func testNilDataToCalculate() {

        networkService = MockNetworkService(allData: AllData(error: nil, message: nil, data: nil))
        presenter = MainPresenter(view: view, networkService: networkService, router: router)
        
        let sum = presenter.calculate(amountString: "1", fromCountry: 0, toCountry: 1, viewCountry: "Second")
        
        XCTAssertNotNil(sum)
        let sumDouble = sum.removeFormatAmount()
        XCTAssertEqual(sumDouble, 0.0)
    }
    
    func testRatesToCalculate() {
        let rates = Rates(buyRate: "Baz", sellRate: "Baz", dateStart: "2022-06-15 13:12:06")
        let valute = Valute(title: "Baz", titleAlias: "Bar", id: "1", rates: rates)
        let valutes = [valute,valute]
        let data = ["Bof" : valutes[0], "Bod" : valutes[1]]
        let allData = AllData(error: false, message: "Foo", data: data)
        
        networkService = MockNetworkService(allData: allData)
        presenter = MainPresenter(view: view, networkService: networkService, router: router)
        presenter.valutes = valutes
        
        let amountString = "10000000".asCurrency()!
        
        let sum = presenter.calculate(amountString: amountString, fromCountry: 0, toCountry: 1, viewCountry: "Second")

        XCTAssertNotNil(sum)

    }
    
    func testStringSumToCalculate() {

        networkService = MockNetworkService(allData: AllData(error: nil, message: nil, data: nil))
        presenter = MainPresenter(view: view, networkService: networkService, router: router)
        
        let sum = presenter.calculate(amountString: "werwer", fromCountry: 0, toCountry: 1, viewCountry: "Second")
        
        XCTAssertNotNil(sum)
    }
}
