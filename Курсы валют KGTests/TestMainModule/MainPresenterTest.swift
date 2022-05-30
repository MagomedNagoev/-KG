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

class MockNetworkService: NetworkServiceProtocol {
    var allData: AllData?
    init() {}
    convenience init(allData: AllData) {
        self.init()
        self.allData = allData
    }

    func getAllData(completion: @escaping (Result<AllData?, Error>) -> Void) {
        if let allData = allData {
            completion(.success(allData))
        } else {
            let error = NSError(domain: "", code: 0, userInfo: nil)
            completion(.failure(error))
        }
    }
}

class MainPresenterTest: XCTestCase {
    var view: MockView!
    var presenter: MainPresenter!
    var networkService: NetworkServiceProtocol!
    var router: RouterProtocol!
    
    override func setUp() {
        let rates = Rates(buyRate: "1", sellRate: "1", dateStart: "2022-06-15 13:12:06")
        let valute = Valute(title: "Baz", titleAlias: "Bar", id: "1", rates: rates)
        let valutes = [valute,valute]
        let data = ["Bof" : valutes[0], "Bod" : valutes[1]]
        let allData = AllData(error: false, message: "Foo", data: data)
        networkService = MockNetworkService(allData: allData)
        presenter = MainPresenter(view: view, networkService: networkService, router: router)
        presenter.valutes = valutes
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
        var catchData: AllData?
        
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
        let sum = presenter.calculate(amountString: "100", fromCountry: 0, toCountry: 1, viewCountry: "First")
        guard let sumDouble = Double(sum) else {
            XCTFail()
            return
        }
        XCTAssertNotNil(sum)
        XCTAssertNotEqual(sumDouble, 0.0)
    }
    
    func testFailCalculate() {
        let sum = presenter.calculate(amountString: "0", fromCountry: 0, toCountry: 1, viewCountry: "First")
        guard let sumDouble = Double(sum) else {
            XCTFail()
            return
        }
        XCTAssertEqual(sumDouble, 0.0)
    }
}
