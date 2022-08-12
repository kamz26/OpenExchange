//
//  LatestCurrencyApiServiceProtocol.swift
//  OpenExchange
//
//  Created by Abhishek Kashyap on 12/08/22.
//

import Foundation

protocol LatestCurrencyApiServiceProtocol{
  func getLatestCurrenciesData(completion: @escaping ((CurrencyListModel?,Error?) -> Void))
}
