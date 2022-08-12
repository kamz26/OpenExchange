//
//  ApiService.swift
//  OpenExchange
//
//  Created by Abhishek Kashyap on 10/08/22.
//

import Foundation

class OpenExchangeApiService:ApiServiceProtocol{
  
  var APIKEY: String{
    return NetworkConstant.APIKey
  }
  
  var baseUrl: String{
    return NetworkConstant.baseUrl
  }
  
  final func apiCall<T:Codable>(endPoint:EndPoint,queryParams:[QueryParameter] ,objectType:T.Type, completion:@escaping ((T?,Error?)-> Void)) {
    guard let request = getApiRequest(endPoint: endPoint,queryParameters: queryParams) else {return}
    
    URLSession.shared.dataTask(with: request) { data, response, error in
      guard error == nil else {
        completion(nil,error)
        return
      }
      
      if let jsonData = data{
        jsonData.printJson()
        do{
          let currencies = try JSONDecoder().decode(T.self, from: jsonData)
          completion(currencies,nil)
        }catch(let parsingError){
          completion(nil,parsingError)
        }
        
      }
    }.resume()
  }
  
  private func getApiRequest(endPoint:EndPoint, queryParameters:[QueryParameter]) -> URLRequest?{
    let finalUrl = baseUrl + endPoint.rawValue + getQueryParameterValues(query: queryParameters)
    if let url = URL(string: finalUrl){
      return  URLRequest(url: url)
    }
    return nil
  }
  
  private func getQueryParameterValues(query:[QueryParameter]) -> String{
    var queryValue = "?\(QueryParameter.getParameterValue(query: QueryParameter.appID(appID: NetworkConstant.APIKey)))"
    guard query.count > 0 else { return queryValue}
    for item in query{
      queryValue += "&\(QueryParameter.getParameterValue(query: item))"
    }
    return queryValue
  }
  
  
}



fileprivate extension Data {
    func printJson() {
        do {
            let json = try JSONSerialization.jsonObject(with: self, options: [])
            let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            guard let jsonString = String(data: data, encoding: .utf8) else {
                print("Inavlid data")
                return
            }
            print("response:\(jsonString)")
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}
