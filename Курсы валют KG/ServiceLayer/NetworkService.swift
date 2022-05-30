//
//  NetworkService.swift
//  Курсы валют KG
//
//  Created by Нагоев Магомед on 18.03.2022.
//

import Foundation

protocol NetworkServiceProtocol {
    func getAllData(completion: @escaping (Result<AllData?, Error>) -> Void)
}

class NetworkService: NetworkServiceProtocol {
    func getAllData(completion: @escaping (Result<AllData?, Error>) -> Void) {
        let urlString = "https://valuta.kg/api/rate/average.json"
        guard let url = URL(string: urlString) else {return}
        if let cachedRates = getCachedData(from: url) {
            completion(.success(cachedRates))
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let response = response else {
                return
            }
            
            do {
                let obj = try JSONDecoder().decode(AllData.self, from: data)
                self.saveDataToCache(with: data, and: response)
                completion(.success(obj))
            } catch let error {
                completion(.failure(error))
            }
        }.resume()
    }
    
    private func getCachedData(from url: URL) -> AllData? {
        let urlRequest = URLRequest(url: url)
        if let cachedResponse = URLCache.shared.cachedResponse(for: urlRequest) {
            do {
                let obj = try JSONDecoder().decode(AllData.self, from: cachedResponse.data)
                print("загрузка кэша")
                return obj
            } catch let error {
                print(error)
            }
        }
        return nil
    }

    private func saveDataToCache(with data: Data, and response: URLResponse) {
            guard let url = response.url else { return }
            let urlRequest = URLRequest(url: url)
            let cachedResponse = CachedURLResponse(response: response, data: data)
            URLCache.shared.storeCachedResponse(cachedResponse, for: urlRequest)
        print("закэшилось")
        }
}
