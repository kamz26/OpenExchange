//
//  CurrencyApiService.swift
//  OpenExchange
//
//  Created by Abhishek Kashyap on 10/08/22.
//

import Foundation

final class LatestCurrencyApiService: LatestCurrencyApiServiceProtocol{
  
  private(set) var currencyApiService:ApiServiceProtocol!
  
  init(apiService:ApiServiceProtocol = OpenExchangeApiService()){
    self.currencyApiService = apiService
  }
  
  func getLatestCurrenciesData(completion: @escaping ((CurrencyListModel?,Error?) -> Void)) {
    currencyApiService.apiCall(endPoint: .latest, queryParams: [], objectType: CurrencyListModel.self){ currencyData, error in
      completion(currencyData,error)
    }
  }
}
