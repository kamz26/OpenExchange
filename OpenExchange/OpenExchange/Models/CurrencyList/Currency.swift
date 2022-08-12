//
//  Currency.swift
//  OpenExchange
//
//  Created by Abhishek Kashyap on 10/08/22.
//

import Foundation
// MARK: - CurrencyListModel
struct CurrencyListModel: Codable {
    let disclaimer: String?
    let license: String?
    let timestamp: Int?
    let base: String?
    let rates: [String: Double]?
}
