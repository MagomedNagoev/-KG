//
//  MockNetworkService.swift
//  Курсы валют KGTests
//
//  Created by Нагоев Магомед on 31.05.2022.
//

import Foundation
@testable import Курсы_валют_KG

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
