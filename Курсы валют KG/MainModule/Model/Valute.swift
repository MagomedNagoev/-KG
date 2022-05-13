//
//  Rate.swift
//  Курсы валют KG
//
//  Created by Нагоев Магомед on 18.03.2022.
//

import Foundation

// MARK: - AllData
struct AllData: Codable {
    let error: Bool?
    let message: String?
    let data: [String: Valute]?
}

// MARK: - Datums
struct Valute: Codable {
    let title, titleAlias, id: String?
    let rates: Rates?

    enum CodingKeys: String, CodingKey {
        case title
        case titleAlias = "title_alias"
        case id, rates
    }
}

// MARK: - Rates
struct Rates: Codable {
    let buyRate, sellRate, dateStart: String?

    enum CodingKeys: String, CodingKey {
        case buyRate = "buy_rate"
        case sellRate = "sell_rate"
        case dateStart = "date_start"
    }
}
