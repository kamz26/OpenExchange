//
//  ApiServiceProtocol.swift
//  OpenExchange
//
//  Created by Abhishek Kashyap on 10/08/22.
//

import Foundation
protocol ApiServiceProtocol{
  var APIKEY:String{get}
  var baseUrl:String{get}
  func apiCall<T:Codable>(endPoint:EndPoint, queryParams:[QueryParameter], objectType:T.Type, completion:@escaping ((T?,Error?)-> Void))
}


enum NetworkConstant{
  static let APIKey   = "7cca6a7b9e174c6db99402ead8f389b9"
  static let baseUrl  = "https://openexchangerates.org/api/"
}

enum EndPoint:String{
  case latest = "latest.json"
}

enum QueryParameter{
  case appID(appID:String)
  
  static func getParameterValue(query:QueryParameter) -> String{
    switch query {
    case .appID(let appID):
      return "app_id=\(appID)"
    }
  }
  
}

